From: manuprivat@gmx.de
Subject: Re: AW: Add new target in mangle table
Date: Tue, 15 Apr 2008 10:35:43 +0200
Message-ID: <20080415083543.20880@gmx.net>
References: <20080414071710.C0E061802C4D8@sovereign.computergmbh.de>
 <alpine.LNX.1.10.0804141827370.9651@fbirervta.pbzchgretzou.qr>
 <20080414163449.293250@gmx.net>
 <alpine.LNX.1.10.0804141844520.9651@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="========GMX20881208248543702595"
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:55923 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753360AbYDOIfp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Apr 2008 04:35:45 -0400
In-Reply-To: <alpine.LNX.1.10.0804141844520.9651@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--========GMX20881208248543702595
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

-------- Original-Nachricht --------
> Datum: Mon, 14 Apr 2008 18:58:41 +0200 (CEST)
> Von: Jan Engelhardt <jengelh@computergmbh.de>
> An: manuprivat@gmx.de
> CC: netfilter-devel@vger.kernel.org
> Betreff: Re: AW: Add new target in mangle table

> 
> On Monday 2008-04-14 18:34, manu wrote:
> >> >>
> >> >># iptables -t mangle -I PREROUTING -i eth2 -s 192.168.0.168 -j SADDR
> >> >>--to-source 10.0.19.2
> >> >
> >> One question this throws up... how do you know the address is
> >> 192.168.0.168?
> >
> >Actually, I dont know that! It is only an example to show the different
> >IP-ranges. Excuse my improper representation.
> 
> The question is more of a technical one-- if you do not know the
> source address the client will be using, how can you reliably
> mangle the address?


I modified the udhcpd from the busybox  - have a look in the attached
file.
To handle the different cases i wrote a shell script - also attached.


-- 
GMX startet ShortView.de. Hier findest Du Leute mit Deinen Interessen!
Jetzt dabei sein: http://www.shortview.de/?mc=sv_ext_mf@gmx

--========GMX20881208248543702595
Content-Type: text/x-csrc; charset="iso-8859-15"; name="dhcpd.c"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="dhcpd.c"

/* dhcpd.c
 *
 * udhcp Server
 * Copyright (C) 1999 Matthew Ramsay <matthewr@moreton.com.au>
 *			Chris Trew <ctrew@moreton.com.au>
 *
 * Rewrite by Russ Dill <Russ.Dill@asu.edu> July 2001
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#include <fcntl.h>
#include <string.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <unistd.h>
#include <signal.h>
#include <errno.h>
#include <sys/ioctl.h>
#include <time.h>
#include <sys/time.h>

#include <netpacket/packet.h>

#include "dhcpd.h"
#include "arpping.h"
#include "socket.h"
#include "options.h"
#include "files.h"
#include "serverpacket.h"
#include "common.h"
#include "signalpipe.h"


/* globals */
struct dhcpOfferedAddr *leases;
struct server_config_t server_config;


#ifdef COMBINED_BINARY	
int udhcpd_main(int argc, char *argv[])
#else
int main(int argc, char *argv[])
#endif
{
	fd_set rfds;
	fd_set thefds;
	struct timeval tv;
	int bytes, retval;
	struct dhcpMessage packet;
	uint8_t *state;
	uint8_t *server_id, *requested;
	uint32_t server_id_align, requested_align;
	unsigned long timeout_end;
	struct option_set *option;
	struct dhcpOfferedAddr *lease;
	int max_sock = 0;
	unsigned long num_ips;
	char buffer[100];
	char *pname;
	int i;
	int lastindex = 0;
	
	memset(&server_config, 0, sizeof(struct server_config_t));
	read_config(argc < 2 ? DHCPD_CONF_FILE : argv[1]);

	/* Start the log, sanitize fd's, and write a pid file */
	start_log_and_pid("udhcpd", server_config.pidfile);

	if ((option = find_option(server_config.options, DHCP_LEASE_TIME))) {
		memcpy(&server_config.lease, option->data + 2, 4);
		server_config.lease = ntohl(server_config.lease);
	}
	else server_config.lease = LEASE_TIME;

	/* Sanity check */
	server_config.end = ntohl(server_config.start);
	server_config.end = htonl(server_config.end + (server_config.max_leases - 1) * server_config.offset);
	num_ips = (ntohl(server_config.end) - ntohl(server_config.start)) / server_config.offset + 1;
	if (server_config.max_leases > num_ips) {
		LOG(LOG_ERR, "max_leases value (%lu) not sane, "
			"setting to %lu instead",
			server_config.max_leases, num_ips);
		server_config.max_leases = num_ips;
	}

	leases = xcalloc(server_config.max_leases, sizeof(struct dhcpOfferedAddr));
	read_leases(server_config.lease_file);

	server_config.numofinterfaces = 0;
	pname = strtok(server_config.interfaces, " ");
	while (pname) {
		server_config.ifname[server_config.numofinterfaces] = pname;
		server_config.fds[server_config.numofinterfaces] = -1;
		server_config.arpfds[server_config.numofinterfaces] = -1;
		if (read_interface(server_config.ifname[server_config.numofinterfaces],
				&server_config.ifindex[server_config.numofinterfaces],
				&server_config.server[server_config.numofinterfaces],
				server_config.arp[server_config.numofinterfaces]) < 0)
			return 1;
		server_config.numofinterfaces++;
		pname = strtok(0, " ");
	}
	server_config.currentinterface = 0;

/* #ifndef UDHCP_DEBUG */
	background(server_config.pidfile); /* hold lock during fork. */
/* #endif */

	FD_ZERO(&thefds);
	FD_ZERO(&rfds);

	/* Setup the signal pipe */
	udhcp_sp_setup();

	timeout_end = time(0) + server_config.auto_time;
	while(1) { /* loop until universe collapses */

		for (i = 0; i < server_config.numofinterfaces; i++) {
			if (server_config.fds[i] < 0)
				if ((server_config.fds[i] = listen_socket(INADDR_ANY, SERVER_PORT,
						server_config.ifname[i])) < 0) {
					LOG(LOG_ERR, "FATAL: couldn't create server socket, %m");
					return 2;
				}

			if (server_config.ippnp) {
				if (server_config.arpfds[i] < 0) {
					if ((server_config.arpfds[i] = 
						arp_socket(server_config.ifname[i], server_config.ifindex[i])) < 0) {
						LOG(LOG_ERR, "FATAL: couldn't create arp socket, %m");
						return 2;
					}
				}
			}

			max_sock = udhcp_sp_fd_set(&thefds, server_config.fds[i]);
			if (server_config.ippnp) {
				max_sock = udhcp_sp_fd_set(&thefds, server_config.arpfds[i]);
			}
		}
		if (server_config.auto_time) {
			tv.tv_sec = timeout_end - time(0);
			tv.tv_usec = 0;
		}
		memcpy(&rfds, &thefds, sizeof(fd_set));
		if (!server_config.auto_time || tv.tv_sec > 0) {
			retval = select(max_sock + 1, &rfds, NULL, NULL, 
					server_config.auto_time ? &tv : NULL);
		} else retval = 0; /* If we already timed out, fall through */

		if (retval == 0) {
			write_leases();
			timeout_end = time(0) + server_config.auto_time;
			continue;
		} else if (retval < 0 && errno != EINTR) {
			DEBUG(LOG_INFO, "error on select");
			continue;
		}
		
		switch (udhcp_sp_read(&rfds)) {
		case SIGUSR1:
			LOG(LOG_INFO, "Received a SIGUSR1");
			write_leases();
			/* why not just reset the timeout, eh */
			timeout_end = time(0) + server_config.auto_time;
			continue;
		case SIGTERM:
			LOG(LOG_INFO, "Received a SIGTERM");
			write_leases();
			return 0;
		case 0: break;		/* no signal */
		default: continue;	/* signal or error (probably EINTR) */
		}

		for (i = lastindex; i < (server_config.numofinterfaces * 2); i++) {
			if (FD_ISSET(server_config.fds[i % server_config.numofinterfaces], &rfds)) {
				server_config.currentinterface = i % server_config.numofinterfaces;
				lastindex = server_config.currentinterface + 1;
				break;
			}

			if (server_config.ippnp) {
				if (FD_ISSET(server_config.arpfds[i % server_config.numofinterfaces], &rfds)) {
					server_config.currentinterface = i % server_config.numofinterfaces;
					lastindex = server_config.currentinterface + 1;
					break;
				}
			}

		}

		if (server_config.ippnp) {
			if (FD_ISSET(server_config.arpfds[server_config.currentinterface], &rfds)) {
				unsigned char buf[1024];
				struct sockaddr_ll sll;
				int sll_len = sizeof(sll);
				int n;

				n = recvfrom(server_config.arpfds[server_config.currentinterface], 
						buf, sizeof(buf), MSG_DONTWAIT, (struct sockaddr*)&sll, &sll_len);
				if (n < 0) {
					DEBUG(LOG_INFO, "error receiving arp");
				}
				else {
					DEBUG(LOG_INFO, "received arp on %s %d", server_config.ifname[server_config.currentinterface], n);
					handleArpPacket(buf);
				}
			}
		}

		if (FD_ISSET(server_config.fds[server_config.currentinterface], &rfds)) {
			if ((bytes = get_packet(&packet, server_config.fds[server_config.currentinterface])) < 0) {
				if (bytes == -1 && errno != EINTR) {
					DEBUG(LOG_INFO, "error on read, %m, reopening socket");
					close(server_config.fds[server_config.currentinterface]);
					max_sock = udhcp_sp_fd_unset(&thefds, server_config.fds[i]);
					server_config.fds[server_config.currentinterface] = -1;
				}
				continue;
			}
		}
		else
			continue;

		if ((state = get_option(&packet, DHCP_MESSAGE_TYPE)) == NULL) {
			DEBUG(LOG_ERR, "couldn't get option from packet, ignoring");
			continue;
		}
		
		/* ADDME: look for a static lease */
		lease = find_lease_by_chaddr(packet.chaddr);

		if (lease && lease->ippnpaddr) { /* The computer with this mac was seen with fixed ip address before */
			char buf[256];

			sprintf(buf, "ippnpremove %02X:%02X:%02X:%02X:%02X:%02X %d.%d.%d.%d %s", 
				lease->chaddr[0], lease->chaddr[1], lease->chaddr[2],
				lease->chaddr[3], lease->chaddr[4], lease->chaddr[5],
				(lease->yiaddr) & 0xff, (lease->yiaddr >> 8) & 0xff,
				(lease->yiaddr >> 16) & 0xff, (lease->yiaddr >> 24) & 0xff,
				lease->ifname);
			system(buf);
		}

		switch (state[0]) {
		case DHCPDISCOVER:
			DEBUG(LOG_INFO,"received DISCOVER");

			sprintf(buffer, "dhcpd.sh discover %02X:%02X:%02X:%02X:%02X:%02X %s",
				packet.chaddr[0], packet.chaddr[1], packet.chaddr[2],
				packet.chaddr[3], packet.chaddr[4], packet.chaddr[5], server_config.ifname[server_config.currentinterface]);
			if (WEXITSTATUS(system(buffer)) == 0) {
				if (sendOffer(&packet) < 0) {
					LOG(LOG_ERR, "send OFFER failed");
				}
			}
			break;			
 		case DHCPREQUEST:
			DEBUG(LOG_INFO, "received REQUEST");

			requested = get_option(&packet, DHCP_REQUESTED_IP);
			server_id = get_option(&packet, DHCP_SERVER_ID);

			if (requested) memcpy(&requested_align, requested, 4);
			if (server_id) memcpy(&server_id_align, server_id, 4);
		
			if (lease) { /*ADDME: or static lease */

				sprintf(buffer, "dhcpd.sh dhcprequest %02X:%02X:%02X:%02X:%02X:%02X %d.%d.%d.%d %s",
					packet.chaddr[0], packet.chaddr[1], packet.chaddr[2],
					packet.chaddr[3], packet.chaddr[4], packet.chaddr[5],
					lease->yiaddr & 0xff, (lease->yiaddr >> 8) & 0xff,
					(lease->yiaddr >> 16) & 0xff, (lease->yiaddr >> 24) & 0xff,
					server_config.ifname[server_config.currentinterface]);

				if (server_id) {
					/* SELECTING State */
					DEBUG(LOG_INFO, "server_id = %08x", ntohl(server_id_align));
					if (server_id_align == server_config.server[server_config.currentinterface] && requested && 
					    requested_align == lease->yiaddr) {
						if (WEXITSTATUS(system(buffer)) == 0)
							sendACK(&packet, lease->yiaddr);
					}
				} else {
					if (requested) {
						/* INIT-REBOOT State */
						if (lease->yiaddr == requested_align) {
							if (WEXITSTATUS(system(buffer)) == 0)
								sendACK(&packet, lease->yiaddr);
						}
						else sendNAK(&packet);
					} else {
						/* RENEWING or REBINDING State */
						if (lease->yiaddr == packet.ciaddr) {
							if (WEXITSTATUS(system(buffer)) == 0)
								sendACK(&packet, lease->yiaddr);
						}
						else {
							/* don't know what to do!!!! */
							sendNAK(&packet);
						}
					}						
				}
			
			/* what to do if we have no record of the client */
			} else if (server_id) {
				/* SELECTING State */

			} else if (requested) {
				/* INIT-REBOOT State */
				if ((lease = find_lease_by_yiaddr(requested_align))) {
					if (lease_expired(lease)) {
						/* probably best if we drop this lease */
						memset(lease->chaddr, 0, 16);
					/* make some contention for this address */
					} else sendNAK(&packet);
				} else if (requested_align < server_config.start || 
					   requested_align > server_config.end ||
					   ((requested_align - server_config.start) % server_config.start) == 1) {
					sendNAK(&packet);
				} /* else remain silent */

			} else {
				 /* RENEWING or REBINDING State */
			}
			break;
		case DHCPDECLINE:
			DEBUG(LOG_INFO,"received DECLINE");
			if (lease) {
				memset(lease->chaddr, 0, 16);
				lease->expires = time(0) + server_config.decline_time;
			}			
			break;
		case DHCPRELEASE:
			DEBUG(LOG_INFO,"received RELEASE");

			if (lease) {
				sprintf(buffer, "dhcpd.sh release %02X:%02X:%02X:%02X:%02X:%02X %d.%d.%d.%d %s",
					packet.chaddr[0], packet.chaddr[1], packet.chaddr[2],
					packet.chaddr[3], packet.chaddr[4], packet.chaddr[5],
					lease->yiaddr & 0xff, (lease->yiaddr >> 8) & 0xff,
					(lease->yiaddr >> 16) & 0xff, (lease->yiaddr >> 24) & 0xff,
					server_config.ifname[server_config.currentinterface]);
				system(buffer);			
				lease->expires = time(0);
			}
			break;
		case DHCPINFORM:
			DEBUG(LOG_INFO,"received INFORM");
			if (lease) {
				sprintf(buffer, "dhcpd.sh inform %02X:%02X:%02X:%02X:%02X:%02X %d.%d.%d.%d %s",
					packet.chaddr[0], packet.chaddr[1], packet.chaddr[2],
					packet.chaddr[3], packet.chaddr[4], packet.chaddr[5],
					lease->yiaddr & 0xff, (lease->yiaddr >> 8) & 0xff,
					(lease->yiaddr >> 16) & 0xff, (lease->yiaddr >> 24) & 0xff,
					server_config.ifname[server_config.currentinterface]);
				system(buffer);						
				send_inform(&packet, lease->yiaddr);
			}
			break;	
		default:
			LOG(LOG_WARNING, "unsupported DHCP message (%02x) -- ignoring", state[0]);
		}
	}

	return 0;
}


--========GMX20881208248543702595
Content-Type: application/x-shellscript; name="dhcpd.sh"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="dhcpd.sh"

IyEvYmluL2FzaAoKLiAvc3lzdGVtL2RhdGEvZ2VuZXJhbC5jZmcKLiAvc3lzdGVtL2RhdGEvbmV0
d29yay5jZmcKCnJlbW92ZWVudHJpZXMgKCApIHsKCWlmIFsgIiQyIiA9ICIiIF07IHRoZW4KCQlp
cGFkZHI9YGVidGFibGVzIC10IG5hdCAtTCBQUkVST1VUSU5HIC0tTG1hYzIgLS1MbiB8IGdyZXAg
JDEgfCBhd2sgJy8uLyB7IHByaW50ICQ3IH0nYAoJZWxzZQoJCWlwYWRkcj0kMgoJZmkKCglpZiBb
ICIkaXBhZGRyIiAhPSAiIiBdOyB0aGVuCgkJbWFjPWBlYnRhYmxlcyAtdCBuYXQgLUwgUFJFUk9V
VElORyAtLUxtYWMyIC0tTG4gfCBncmVwICRpcGFkZHIgfCBncmVwIGFycHJlcGx5LW1hYyB8IGF3
ayAnLy4vIHsgcHJpbnQgJDExIH0nYAoJCWVidGFibGVzIC10IG5hdCAtTCBQUkVST1VUSU5HIC0t
TG1hYzIgLS1MbiB8IGdyZXAgJGlwYWRkciB8IGF3ayAnLy4vIHsgc3lzdGVtKCJlYnRhYmxlcyAt
dCBuYXQgLUQgUFJFUk9VVElORyAiIHN1YnN0cigkMSwgMSwgbGVuZ3RoKCQxKSAtIDEpICsgMSAt
IE5SKSB9JwoJCWlmIFsgIiRtYWMiICE9ICIiIF07IHRoZW4KCQkJZWJ0YWJsZXMgLXQgbmF0IC1M
IFBPU1RST1VUSU5HIC0tTG1hYzIgLS1MbiB8IGdyZXAgJG1hYyB8IGF3ayAnLy4vIHsgc3lzdGVt
KCJlYnRhYmxlcyAtdCBuYXQgLUQgUE9TVFJPVVRJTkcgIiBzdWJzdHIoJDEsIDEsIGxlbmd0aCgk
MSkgLSAxKSArIDEgLSBOUikgfScKCQlmaQoJZmkKCXJtIC1mIC90bXAvbWFjdG1wXyQyCglybSAt
ZiAvdG1wL21hY3RwXyQyLmxvZ2dlZAp9CgphZGRlbnRyaWVzICggKSB7CglpZiBbICIkNSIgPSAi
IiBdOyB0aGVuCgkJaWYgWyAtZSAvdG1wL21hY3RtcF8kMiBdOyB0aGVuCgkJCWlmIFsgLWUgL3Rt
cC9tYWN0cF8kMi5sb2dnZWQgXTsgdGhlbgoJCQkJbG9nZ2VyICQxIGFkYXB0ZXIgZm9yICQyIG9u
ICQ0IGRvZXMgbm90IGV4aXN0CgkJCWVsc2UKCQkJCXRvdWNoIC90bXAvbWFjdHBfJDIubG9nZ2Vk
CgkJCQlsb2dnZXIuc2ggc3lzY2hlY2sgIk5vIGJyaWRnZXRhYmxlIGVudHJ5IGZvciAkMiIKCQkJ
ZmkgCgkJZWxzZQoJCQlsb2dnZXIgJDEgYWRhcHRlciBmb3IgJDIgb24gJDQgZG9lcyBub3QgZXhp
c3QKCQkJdG91Y2ggL3RtcC9tYWN0cF8kMgoJCWZpCgkJZXhpdCAxCgllbHNlCgkJbG9nZ2VyICQx
IGFkYXB0ZXIgZm9yICQyIG9uICQ0IGlzICQ1CgoJCXJtIC1mIC90bXAvbWFjdG1wXyQyCgkJcm0g
LWYgL3RtcC9tYWN0cF8kMi5sb2dnZWQKCgkJaWYgWyAiJE5FVF9MQU5NQVBTVEFSVCIgIT0gIiIg
XTsgdGhlbgoJCQl3YW5iYXNpcz1gZWNobyAkTkVUX0xBTk1BUFNUQVJUIHwgYXdrIC1GIFwuICcv
Li8geyBwcmludCAkMSAiLiIgJDIgIi4iICQzIH0nYAoJCQl3YW5zdGFydD1gZWNobyAkTkVUX0xB
Tk1BUFNUQVJUIHwgYXdrIC1GIFwuICcvLi8geyBwcmludCAkNCB9J2AKCQkJaWYgWyAiJE5FVF9M
QU5TVUJORVRESUZGIiA9ICJvbiIgXTsgdGhlbgoJCQkJc3RhcnQ9YGVjaG8gJE5FVF9MQU5MRUFT
RVNUQVJUIHwgYXdrIC1GIFwuICcvLi8geyBwcmludCAkMyB9J2AKCQkJCWN1cnI9YGVjaG8gJDMg
fCBhd2sgLUYgXC4gJy8uLyB7IHByaW50ICQzIH0nYAoJCQkJY3Vycj1gZXhwciAkd2Fuc3RhcnQg
KyAkY3VyciAtICRzdGFydGAKCQkJZWxzZQoJCQkJc3RhcnQ9YGVjaG8gJE5FVF9MQU5MRUFTRVNU
QVJUIHwgYXdrIC1GIFwuICcvLi8geyBwcmludCAkNCB9J2AKCQkJCWN1cnI9YGVjaG8gJDMgfCBh
d2sgLUYgXC4gJy8uLyB7IHByaW50ICQ0IH0nYAoJCQkJY3Vycj1gZXhwciAkd2Fuc3RhcnQgKyAk
Y3VyciAtICRzdGFydGAKCQkJZmkKCQlmaQoJCXJlbW92ZWVudHJpZXMgJDIgJHdhbmJhc2lzLiRj
dXJyCgkJZWJ0YWJsZXMgLXQgbmF0IC1JIFBPU1RST1VUSU5HIDEgLW8gJE5FVF9XQU5JRkFDRSAt
cCAweDgwMCAtLWlwLXNvdXJjZSAkMyAtaiBzbmF0IC0tdG8tc291cmNlICQ1CgkJZWJ0YWJsZXMg
LXQgbmF0IC1JIFBSRVJPVVRJTkcgMSAtaSAkTkVUX1dBTklGQUNFIC1wIDB4ODAwIC1kICQ1IC0t
aXAtZGVzdGluYXRpb24gJHdhbmJhc2lzLiRjdXJyIC1qIGRuYXQgLS10by1kZXN0aW5hdGlvbiAk
MgoJCWVidGFibGVzIC10IG5hdCAtSSBQUkVST1VUSU5HIDEgLWkgJE5FVF9XQU5JRkFDRSAtcCAw
eDgwNiAtLWFycC1pcC1kc3QgJHdhbmJhc2lzLiRjdXJyIC1qIGFycHJlcGx5IC0tYXJwcmVwbHkt
bWFjICQ1CgoJCWV4aXQgMAoJZmkKfQoKYnJpZGdlX2RoY3ByZXF1ZXN0ICggKSB7CglpZiBbICIk
TkVUX0xBTk1BUFNUQVJUIiAhPSAiIiBdOyB0aGVuCgkJd2FuYmFzaXM9YGVjaG8gJE5FVF9MQU5N
QVBTVEFSVCB8IGF3ayAtRiBcLiAnLy4vIHsgcHJpbnQgJDEgIi4iICQyICIuIiAkMyB9J2AKCQl3
YW5zdGFydD1gZWNobyAkTkVUX0xBTk1BUFNUQVJUIHwgYXdrIC1GIFwuICcvLi8geyBwcmludCAk
NCB9J2AKCQlpZiBbICIkTkVUX0xBTlNVQk5FVERJRkYiID0gIm9uIiBdOyB0aGVuCgkJCXN0YXJ0
PWBlY2hvICRORVRfTEFOTEVBU0VTVEFSVCB8IGF3ayAtRiBcLiAnLy4vIHsgcHJpbnQgJDMgfSdg
CgkJCWN1cnI9YGVjaG8gJDMgfCBhd2sgLUYgXC4gJy8uLyB7IHByaW50ICQzIH0nYAoJCQljdXJy
PWBleHByICR3YW5zdGFydCArICRjdXJyIC0gJHN0YXJ0YAoJCWVsc2UKCQkJc3RhcnQ9YGVjaG8g
JE5FVF9MQU5MRUFTRVNUQVJUIHwgYXdrIC1GIFwuICcvLi8geyBwcmludCAkNCB9J2AKCQkJY3Vy
cj1gZWNobyAkMyB8IGF3ayAtRiBcLiAnLy4vIHsgcHJpbnQgJDQgfSdgCgkJCWN1cnI9YGV4cHIg
JHdhbnN0YXJ0ICsgJGN1cnIgLSAkc3RhcnRgCgkJZmkKCWZpCgllYnRhYmxlcyAtdCBuYXQgLUwg
UFJFUk9VVElORyAtLUxtYWMyIC0tTG4gfCBncmVwICR3YW5iYXNpcy4kY3VyciB8IGF3ayAnLy4v
IHsgc3lzdGVtKCJlYnRhYmxlcyAtdCBuYXQgLUQgUFJFUk9VVElORyAiIHN1YnN0cigkMSwgMSwg
bGVuZ3RoKCQxKSAtIDEpICsgMSAtIE5SKSB9JwoJZWJ0YWJsZXMgLXQgbmF0IC1JIFBSRVJPVVRJ
TkcgMSAtaSAkTkVUX1dBTklGQUNFIC1wIDB4ODA2IC0tYXJwLWlwLWRzdCAkd2FuYmFzaXMuJGN1
cnIgLWogYXJwcmVwbHkgLS1hcnByZXBseS1tYWMgJDIKfQoKbWFjbmF0X2Rpc2NvdmVyICggKSB7
CglyZW1vdmVlbnRyaWVzICQyCgojCWlmIFsgIiRORVRfUkJSSURHRVJFVFJZIiA9ICIiIF07IHRo
ZW4KIwkJTkVUX1JCUklER0VSRVRSWT0xCiMJZmkKIwlpPTAKIwllbnRyeT0iIgojCXdoaWxlIFsg
IiRlbnRyeSIgPSAiIiAtYSAiJGkiICE9ICIkTkVUX1JCUklER0VSRVRSWSIgXTsgZG8KIwkJcGxj
dG9vbCAtZCAkMyAtcmJyaWRnZSBGRjpGRjpGRjpGRjpGRjpGRiA+IC90bXAvYnJpZGdlbGlzdCAy
Pi90bXAvYnJpZGdlbG9nCiMJCWVudHJ5PWBncmVwICQyIC90bXAvYnJpZGdlbGlzdCB8IGF3ayAn
Ly4vIHsgcHJpbnQgJDIgfSdgCiMJCWk9YGV4cHIgJGkgKyAxYAojCWRvbmUKIwojCWlmIFsgIiRl
bnRyeSIgPSAiIiBdOyB0aGVuCiMJCWxvZ2dlciAkMSBhZGFwdGVyIGZvciAkMiBvbiAkMyBkb2Vz
IG5vdCBleGlzdAojCQlleGl0IDEKIwllbHNlCiMJCWxvZ2dlciAkMSBhZGFwdGVyIGZvciAkMiBv
biAkMyBpcyAkZW50cnkKIwkJZXhpdCAwCiMJZmkKCWV4aXQgMAp9CgptYWNuYXRfZGhjcHJlcXVl
c3QgKCApIHsKCWlmIFsgIiRORVRfUkJSSURHRVJFVFJZIiA9ICIiIF07IHRoZW4KCQlORVRfUkJS
SURHRVJFVFJZPTEKCWZpCglpPTAKCWVudHJ5PSIiCgl3aGlsZSBbICIkZW50cnkiID0gIiIgLWEg
IiRpIiAhPSAiJE5FVF9SQlJJREdFUkVUUlkiIF07IGRvCgkJcGxjdG9vbCAtZCAkNCAtcmJyaWRn
ZSBGRjpGRjpGRjpGRjpGRjpGRiA+IC90bXAvYnJpZGdlbGlzdCAyPi90bXAvYnJpZGdlbG9nCgkJ
ZW50cnk9YGdyZXAgJDIgL3RtcC9icmlkZ2VsaXN0IHwgYXdrICcvLi8geyBwcmludCAkMiB9J2AK
CQlpPWBleHByICRpICsgMWAKCWRvbmUKCglhZGRlbnRyaWVzICQxICQyICQzICQ0ICIkZW50cnki
Cn0KCmNhdG5hdF9kaXNjb3ZlciAoICkgewoJaWQ9YGVjaG8gJDMgfCBhd2sgLXYgc3RhcnQ9JE5F
VF9MQU5DQVRTVEFSVCAtdiBjb3VudD0kTkVUX0xBTkNBVENPVU5UIC1GIFwuICcvLi8gewoJCWlm
ICgoJDIgIT0gIiIpICYmICgkMiA+PSBzdGFydCkgJiYgKCQyIDwgKHN0YXJ0ICsgY291bnQpKSkK
CQkJcHJpbnQgKCQyIC0gc3RhcnQpCgl9J2AKCWlmIFsgIiRpZCIgIT0gIiIgXTsgdGhlbgoJCXJl
bW92ZWVudHJpZXMgJDIKCQlleGl0IDAKCWZpCn0KCmNhdG5hdF9kaGNwcmVxdWVzdCAoICkgewoJ
aWQ9YGVjaG8gJDQgfCBhd2sgLXYgc3RhcnQ9JE5FVF9MQU5DQVRTVEFSVCAtdiBjb3VudD0kTkVU
X0xBTkNBVENPVU5UIC1GIFwuICcvLi8gewoJCWlmICgoJDIgIT0gIiIpICYmICgkMiA+PSBzdGFy
dCkgJiYgKCQyIDwgKHN0YXJ0ICsgY291bnQpKSkKCQkJcHJpbnQgKCQyIC0gc3RhcnQpCgl9J2AK
CWlmIFsgIiRpZCIgIT0gIiIgXTsgdGhlbgoJCW1hYz1gZWNobyAkTkVUX0xBTkNBVE1BQ1NUQVJU
IHwgYXdrIC1GIFw6IC12IGluZD0kaWQgJ0JFR0lOIHsgc3VtID0gMDsKICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICBhWyIwIl0gPSAwOwogICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIGFbIjEiXSA9IDE7CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgYVsiMiJdID0g
MjsKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBhWyIzIl0gPSAzOwogICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIGFbIjQiXSA9IDQ7CiAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgYVsiNSJdID0gNTsKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBhWyI2
Il0gPSA2OwogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGFbIjciXSA9IDc7CiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgYVsiOCJdID0gODsKICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBhWyI5Il0gPSA5OwogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IGFbIkEiXSA9IDEwOwogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGFbIkIiXSA9IDEx
OwogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGFbIkMiXSA9IDEyOwogICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIGFbIkQiXSA9IDEzOwogICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIGFbIkUiXSA9IDE0OwogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGFb
IkYiXSA9IDE1OwoJCQl9CiAgICAgICAgCSAgICAgICAgLy4vIHsKCQkJCWZvciAoaSA9IDE7IGkg
PD0gTkY7IGkrKykgewoJCQkJCXN1bSArPSAoYVt0b3VwcGVyKHN1YnN0cigkaSwgMSwgMSkpXSAq
IDE2ICsgYVt0b3VwcGVyKHN1YnN0cigkaSwgMiwgMSkpXSkgKiAoMjU2IF4gKDYgLSBpKSk7CgkJ
CQl9CgkJCQlzdW0gKz0gaW5kOwoJCQkJcHJpbnRmKCIlMFg6JTBYOiUwWDolMFg6JTBYOiUwWFxu
IiwKCQkJCQkoc3VtIC8gKDI1NiBeIDUpKSAlIDI1NiwKCQkJCQkoc3VtIC8gKDI1NiBeIDQpKSAl
IDI1NiwKCQkJCQkoc3VtIC8gKDI1NiBeIDMpKSAlIDI1NiwKCQkJCQkoc3VtIC8gKDI1NiBeIDIp
KSAlIDI1NiwKCQkJCQkoc3VtIC8gMjU2KSAlIDI1NiwKCQkJCQlzdW0gJSAyNTYpOwoJCX0nYAoJ
CWFkZGVudHJpZXMgJDEgJDIgJDMgJDQgIiRtYWMiCglmaQp9CgoKaGFuZGxlX2Rpc2NvdmVyICgg
KSB7Cglsb2dnZXIgaGFuZGxlX2Rpc2NvdmVyICQxICQyICQzCgoJaWYgWyAiJE5FVF9MQU5DQVRU
UCIgPSAib24iIF07IHRoZW4KCQljYXRuYXRfZGlzY292ZXIgJEAKCWZpCgoJaWYgWyAiJE5FVF9M
QU5NQUNUUCIgPSAib24iIF07IHRoZW4KCQltYWNuYXRfZGlzY292ZXIgJEAKCWZpCn0KCmhhbmRs
ZV9kaGNwcmVxdWVzdCAoICkgewoJbG9nZ2VyIGhhbmRsZV9kaGNwcmVxdWVzdCAkMSAkMiAkMyAk
NAoJaWYgWyAiJE5FVF9XQU5NT0RFIiA9ICJCUklER0UiIF07IHRoZW4KCQlpZmFjZT1gZWNobyAk
NCB8IGF3ayAnL2V0aC8geyBwcmludCAiYnIwIiBzdWJzdHIoJDEsIDUpIH0gL2JyLyB7IHByaW50
ICQxIH0nYAoJZWxzZQoJCWlmYWNlPSQ0CglmaQoKCWlmIFsgIiRORVRfTEFOU1VCTkVURElGRiIg
PSAib24iIF07IHRoZW4KCQlpbmRleD1gZWNobyAkMyB8IGF3ayAtRiBcLiAnLy4vIHsgcHJpbnQg
JDMgfSdgCgkJaXA9YGVjaG8gJDMgfCBhd2sgLUYgXC4gJy8uLyB7IHByaW50ICQxICIuIiAkMiAi
LiIgJDMgIi4xIiB9J2AKCgkJaWZuYW1lPWBpZmNvbmZpZyB8IGF3ayAtdiBpcD0kaXAgJy9IV2Fk
ZHIvIHsgaWZuYW1lPSQxIH0gL2luZXQgYWRkci8geyBpZiAoc3Vic3RyKCQyLCA2KSA9PSBpcCkg
cHJpbnQgaWZuYW1lIH0nYAoJCWlmIFsgIiRpZm5hbWUiID0gIiIgXTsgdGhlbgoJCQlpZmNvbmZp
ZyAkaWZhY2U6JGluZGV4ICRpcCBuZXRtYXNrIDI1NS4yNTUuMjU1LjI1MiB1cAoJCWVsc2UgaWYg
WyAiJGlmbmFtZSIgIT0gIiQ0OiRpbmRleCIgXTsgdGhlbgoJCQlpZmNvbmZpZyAkaWZuYW1lIGRv
d24KCQkJaWZjb25maWcgJGlmYWNlOiRpbmRleCAkaXAgbmV0bWFzayAyNTUuMjU1LjI1NS4yNTIg
dXAKCQlmaQoJCWZpCgllbHNlCgkJcm91dGUgZGVsIC1ob3N0ICQzCgkJcm91dGUgYWRkIC1ob3N0
ICQzICQ0CglmaQoJCiMjIyA+Pj4+Pj4gRm9yY2UgYW55IG9sZCBJUCBQblAgZW50cmllcyB0byBi
ZSByZW1vdmVkIGlmIHJlYWwgREhDUCByZXF1ZXN0CglpZiBbICIkNSIgIT0gIklQUE5QIiBdOyB0
aGVuCgkJbG9nZ2VyIElQIFBuUCBmb3JjZSByZW1vdmUgJDMgJDQKCQlldmFsICJpcHRhYmxlcyAt
dCBtYW5nbGUgLUwgUFJFUk9VVElORyAtbiAteCAtLWxpbmUtbnVtYmVycyB8IGdyZXAgLXYgTUFS
SyB8IGF3ayAnLyQzLyB7IHN5c3RlbShcImlwdGFibGVzIC10IG1hbmdsZSAtRCBQUkVST1VUSU5H
IFwiIFwkMSk7IH0nIgoJCWV2YWwgImlwdGFibGVzIC10IG1hbmdsZSAtTCBQT1NUUk9VVElORyAt
biAteCAtLWxpbmUtbnVtYmVycyB8IGF3ayAnLyQzLyB7IHN5c3RlbShcImlwdGFibGVzIC10IG1h
bmdsZSAtRCBQT1NUUk9VVElORyBcIiBcJDEpOyB9JyIKCQlldmFsICJhcnB0YWJsZXMgLUwgSU5Q
VVQgLW4gLXggLS1saW5lLW51bWJlcnMgfCBhd2sgJy8kMy8geyBzeXN0ZW0oXCJhcnB0YWJsZXMg
LUQgSU5QVVQgXCIgXCQxKTsgfSciCgkJZXZhbCAiYXJwdGFibGVzIC1MIE9VVFBVVCAtbiAteCAt
LWxpbmUtbnVtYmVycyB8IGF3ayAnLyQzLyB7IHN5c3RlbShcImFycHRhYmxlcyAtRCBPVVRQVVQg
XCIgXCQxKTsgfSciCglmaQojIyMgPDw8PDw8CiMjIyA+Pj4+Pj4gRHJvcCBhcnAgcGFja2V0cyB3
aXRoIHNvdXJjZSBhZGRyZXNzIDAuMC4wLjAgKE1hY2ludG9zaCBsZWFzZSBtdW5jaGVyKQoJYXJw
dGFibGVzIC1EIElOUFVUIC0tb3Bjb2RlIDEgLS1oLWxlbmd0aCA2IC1zIDAuMC4wLjAgLWQgJDMg
LWogRFJPUAoJYXJwdGFibGVzIC1JIElOUFVUIC0xIC0tb3Bjb2RlIDEgLS1oLWxlbmd0aCA2IC1z
IDAuMC4wLjAgLWQgJDMgLWogRFJPUAojIyMgPDw8PDw8CglpZiBbIC1lIC92YXIvcnVuL25hbWVk
LnBpZCBdOyB0aGVuCgkJa2lsbCAtSFVQIGBjYXQgL3Zhci9ydW4vbmFtZWQucGlkYAoJZmkKCglp
ZiBbICIkTkVUX0xBTkNBVFRQIiA9ICJvbiIgXTsgdGhlbgoJCWNhdG5hdF9kaGNwcmVxdWVzdCAk
QAoJZmkKCglpZiBbICIkTkVUX0xBTk1BQ1RQIiA9ICJvbiIgXTsgdGhlbgoJCW1hY25hdF9kaGNw
cmVxdWVzdCAkQAoJZWxzZSBpZiBbICIkTkVUX1dBTk1PREUiID0gIkJSSURHRSIgXTsgdGhlbgoJ
CWJyaWRnZV9kaGNwcmVxdWVzdCAkQAoJZmkKCWZpCn0KCmhhbmRsZV9yZWxlYXNlICggKSB7Cgls
b2dnZXIgaGFuZGxlX2RoY3ByZWxlYXNlICQxICQyICQzICQ0CgoJaWYgWyAiJE5FVF9XQU5NT0RF
IiA9ICJCUklER0UiIF07IHRoZW4KCQlyZW1vdmVlbnRyaWVzICQyCglmaQoKCWlmIFsgIiRORVRf
TEFOU1VCTkVURElGRiIgPSAib24iIF07IHRoZW4KCQlpbmRleD1gZWNobyAkMyB8IGF3ayAtRiBc
LiAnLy4vIHsgcHJpbnQgJDMgfSdgCgkJaXA9YGVjaG8gJDMgfCBhd2sgLUYgXC4gJy8uLyB7IHBy
aW50ICQxICIuIiAkMiAiLiIgJDMgIi4xIiB9J2AKCQlpZm5hbWU9YGlmY29uZmlnIHwgYXdrIC12
IGlwPSRpcCAnL0hXYWRkci8geyBpZm5hbWU9JDEgfSAvaW5ldCBhZGRyLyB7IGlmIChzdWJzdHIo
JDIsIDYpID09IGlwKSBwcmludCBpZm5hbWUgfSdgCgkJaWZjb25maWcgJGlmbmFtZSBkb3duCgll
bHNlCgkJcm91dGUgZGVsIC1ob3N0ICQzCglmaQoJaWYgWyAtZSAvdmFyL3J1bi9uYW1lZC5waWQg
XTsgdGhlbgoJCWtpbGwgLUhVUCBgY2F0IC92YXIvcnVuL25hbWVkLnBpZGAKCWZpCn0KCmhhbmRs
ZV9pbmZvcm0gKCApIHsKCWxvZ2dlciBoYW5kbGVfZGhjcGluZm9ybSAkMSAkMiAkMyAkNAp9Cgpp
ZiBbICIkNCIgIT0gImV0aDEiIC1hICIkMyIgIT0gImV0aDEiIF07IHRoZW4KCWhhbmRsZV8kMSAk
QApmaQoKZXhpdCAwCg==
--========GMX20881208248543702595--
