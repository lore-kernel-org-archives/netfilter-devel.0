From: Manu <manuprivat@gmx.de>
Subject: Re: AW: Add new target in mangle table
Date: Tue, 15 Apr 2008 10:10:29 +0200
Message-ID: <1208247029.9868.15.camel@mscheub-lapi.Simpsons>
References: <20080414071710.C0E061802C4D8@sovereign.computergmbh.de>
	 <alpine.LNX.1.10.0804141827370.9651@fbirervta.pbzchgretzou.qr>
	 <20080414163449.293250@gmx.net>
	 <alpine.LNX.1.10.0804141844520.9651@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-4LwezRlim5Hmgzp9y+yx"
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:37859 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753151AbYDOIJl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Apr 2008 04:09:41 -0400
In-Reply-To: <alpine.LNX.1.10.0804141844520.9651@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-4LwezRlim5Hmgzp9y+yx
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

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
> --

I modified the udhcpd from the busybox  - have a look in the attached
file.
To handle the different cases i wrote a shell script - also attached.


--=-4LwezRlim5Hmgzp9y+yx
Content-Disposition: attachment; filename=dhcpd.sh
Content-Type: application/x-shellscript; name=dhcpd.sh
Content-Transfer-Encoding: 7bit

#!/bin/ash

. /system/data/general.cfg
. /system/data/network.cfg

removeentries ( ) {
	if [ "$2" = "" ]; then
		ipaddr=`ebtables -t nat -L PREROUTING --Lmac2 --Ln | grep $1 | awk '/./ { print $7 }'`
	else
		ipaddr=$2
	fi

	if [ "$ipaddr" != "" ]; then
		mac=`ebtables -t nat -L PREROUTING --Lmac2 --Ln | grep $ipaddr | grep arpreply-mac | awk '/./ { print $11 }'`
		ebtables -t nat -L PREROUTING --Lmac2 --Ln | grep $ipaddr | awk '/./ { system("ebtables -t nat -D PREROUTING " substr($1, 1, length($1) - 1) + 1 - NR) }'
		if [ "$mac" != "" ]; then
			ebtables -t nat -L POSTROUTING --Lmac2 --Ln | grep $mac | awk '/./ { system("ebtables -t nat -D POSTROUTING " substr($1, 1, length($1) - 1) + 1 - NR) }'
		fi
	fi
	rm -f /tmp/mactmp_$2
	rm -f /tmp/mactp_$2.logged
}

addentries ( ) {
	if [ "$5" = "" ]; then
		if [ -e /tmp/mactmp_$2 ]; then
			if [ -e /tmp/mactp_$2.logged ]; then
				logger $1 adapter for $2 on $4 does not exist
			else
				touch /tmp/mactp_$2.logged
				logger.sh syscheck "No bridgetable entry for $2"
			fi 
		else
			logger $1 adapter for $2 on $4 does not exist
			touch /tmp/mactp_$2
		fi
		exit 1
	else
		logger $1 adapter for $2 on $4 is $5

		rm -f /tmp/mactmp_$2
		rm -f /tmp/mactp_$2.logged

		if [ "$NET_LANMAPSTART" != "" ]; then
			wanbasis=`echo $NET_LANMAPSTART | awk -F \. '/./ { print $1 "." $2 "." $3 }'`
			wanstart=`echo $NET_LANMAPSTART | awk -F \. '/./ { print $4 }'`
			if [ "$NET_LANSUBNETDIFF" = "on" ]; then
				start=`echo $NET_LANLEASESTART | awk -F \. '/./ { print $3 }'`
				curr=`echo $3 | awk -F \. '/./ { print $3 }'`
				curr=`expr $wanstart + $curr - $start`
			else
				start=`echo $NET_LANLEASESTART | awk -F \. '/./ { print $4 }'`
				curr=`echo $3 | awk -F \. '/./ { print $4 }'`
				curr=`expr $wanstart + $curr - $start`
			fi
		fi
		removeentries $2 $wanbasis.$curr
		ebtables -t nat -I POSTROUTING 1 -o $NET_WANIFACE -p 0x800 --ip-source $3 -j snat --to-source $5
		ebtables -t nat -I PREROUTING 1 -i $NET_WANIFACE -p 0x800 -d $5 --ip-destination $wanbasis.$curr -j dnat --to-destination $2
		ebtables -t nat -I PREROUTING 1 -i $NET_WANIFACE -p 0x806 --arp-ip-dst $wanbasis.$curr -j arpreply --arpreply-mac $5

		exit 0
	fi
}

bridge_dhcprequest ( ) {
	if [ "$NET_LANMAPSTART" != "" ]; then
		wanbasis=`echo $NET_LANMAPSTART | awk -F \. '/./ { print $1 "." $2 "." $3 }'`
		wanstart=`echo $NET_LANMAPSTART | awk -F \. '/./ { print $4 }'`
		if [ "$NET_LANSUBNETDIFF" = "on" ]; then
			start=`echo $NET_LANLEASESTART | awk -F \. '/./ { print $3 }'`
			curr=`echo $3 | awk -F \. '/./ { print $3 }'`
			curr=`expr $wanstart + $curr - $start`
		else
			start=`echo $NET_LANLEASESTART | awk -F \. '/./ { print $4 }'`
			curr=`echo $3 | awk -F \. '/./ { print $4 }'`
			curr=`expr $wanstart + $curr - $start`
		fi
	fi
	ebtables -t nat -L PREROUTING --Lmac2 --Ln | grep $wanbasis.$curr | awk '/./ { system("ebtables -t nat -D PREROUTING " substr($1, 1, length($1) - 1) + 1 - NR) }'
	ebtables -t nat -I PREROUTING 1 -i $NET_WANIFACE -p 0x806 --arp-ip-dst $wanbasis.$curr -j arpreply --arpreply-mac $2
}

macnat_discover ( ) {
	removeentries $2

#	if [ "$NET_RBRIDGERETRY" = "" ]; then
#		NET_RBRIDGERETRY=1
#	fi
#	i=0
#	entry=""
#	while [ "$entry" = "" -a "$i" != "$NET_RBRIDGERETRY" ]; do
#		plctool -d $3 -rbridge FF:FF:FF:FF:FF:FF > /tmp/bridgelist 2>/tmp/bridgelog
#		entry=`grep $2 /tmp/bridgelist | awk '/./ { print $2 }'`
#		i=`expr $i + 1`
#	done
#
#	if [ "$entry" = "" ]; then
#		logger $1 adapter for $2 on $3 does not exist
#		exit 1
#	else
#		logger $1 adapter for $2 on $3 is $entry
#		exit 0
#	fi
	exit 0
}

macnat_dhcprequest ( ) {
	if [ "$NET_RBRIDGERETRY" = "" ]; then
		NET_RBRIDGERETRY=1
	fi
	i=0
	entry=""
	while [ "$entry" = "" -a "$i" != "$NET_RBRIDGERETRY" ]; do
		plctool -d $4 -rbridge FF:FF:FF:FF:FF:FF > /tmp/bridgelist 2>/tmp/bridgelog
		entry=`grep $2 /tmp/bridgelist | awk '/./ { print $2 }'`
		i=`expr $i + 1`
	done

	addentries $1 $2 $3 $4 "$entry"
}

catnat_discover ( ) {
	id=`echo $3 | awk -v start=$NET_LANCATSTART -v count=$NET_LANCATCOUNT -F \. '/./ {
		if (($2 != "") && ($2 >= start) && ($2 < (start + count)))
			print ($2 - start)
	}'`
	if [ "$id" != "" ]; then
		removeentries $2
		exit 0
	fi
}

catnat_dhcprequest ( ) {
	id=`echo $4 | awk -v start=$NET_LANCATSTART -v count=$NET_LANCATCOUNT -F \. '/./ {
		if (($2 != "") && ($2 >= start) && ($2 < (start + count)))
			print ($2 - start)
	}'`
	if [ "$id" != "" ]; then
		mac=`echo $NET_LANCATMACSTART | awk -F \: -v ind=$id 'BEGIN { sum = 0;
                                a["0"] = 0;
                                a["1"] = 1;
                                a["2"] = 2;
                                a["3"] = 3;
                                a["4"] = 4;
                                a["5"] = 5;
                                a["6"] = 6;
                                a["7"] = 7;
                                a["8"] = 8;
                                a["9"] = 9;
                                a["A"] = 10;
                                a["B"] = 11;
                                a["C"] = 12;
                                a["D"] = 13;
                                a["E"] = 14;
                                a["F"] = 15;
			}
        	        /./ {
				for (i = 1; i <= NF; i++) {
					sum += (a[toupper(substr($i, 1, 1))] * 16 + a[toupper(substr($i, 2, 1))]) * (256 ^ (6 - i));
				}
				sum += ind;
				printf("%0X:%0X:%0X:%0X:%0X:%0X\n",
					(sum / (256 ^ 5)) % 256,
					(sum / (256 ^ 4)) % 256,
					(sum / (256 ^ 3)) % 256,
					(sum / (256 ^ 2)) % 256,
					(sum / 256) % 256,
					sum % 256);
		}'`
		addentries $1 $2 $3 $4 "$mac"
	fi
}


handle_discover ( ) {
	logger handle_discover $1 $2 $3

	if [ "$NET_LANCATTP" = "on" ]; then
		catnat_discover $@
	fi

	if [ "$NET_LANMACTP" = "on" ]; then
		macnat_discover $@
	fi
}

handle_dhcprequest ( ) {
	logger handle_dhcprequest $1 $2 $3 $4
	if [ "$NET_WANMODE" = "BRIDGE" ]; then
		iface=`echo $4 | awk '/eth/ { print "br0" substr($1, 5) } /br/ { print $1 }'`
	else
		iface=$4
	fi

	if [ "$NET_LANSUBNETDIFF" = "on" ]; then
		index=`echo $3 | awk -F \. '/./ { print $3 }'`
		ip=`echo $3 | awk -F \. '/./ { print $1 "." $2 "." $3 ".1" }'`

		ifname=`ifconfig | awk -v ip=$ip '/HWaddr/ { ifname=$1 } /inet addr/ { if (substr($2, 6) == ip) print ifname }'`
		if [ "$ifname" = "" ]; then
			ifconfig $iface:$index $ip netmask 255.255.255.252 up
		else if [ "$ifname" != "$4:$index" ]; then
			ifconfig $ifname down
			ifconfig $iface:$index $ip netmask 255.255.255.252 up
		fi
		fi
	else
		route del -host $3
		route add -host $3 $4
	fi
	
### >>>>>> Force any old IP PnP entries to be removed if real DHCP request
	if [ "$5" != "IPPNP" ]; then
		logger IP PnP force remove $3 $4
		eval "iptables -t mangle -L PREROUTING -n -x --line-numbers | grep -v MARK | awk '/$3/ { system(\"iptables -t mangle -D PREROUTING \" \$1); }'"
		eval "iptables -t mangle -L POSTROUTING -n -x --line-numbers | awk '/$3/ { system(\"iptables -t mangle -D POSTROUTING \" \$1); }'"
		eval "arptables -L INPUT -n -x --line-numbers | awk '/$3/ { system(\"arptables -D INPUT \" \$1); }'"
		eval "arptables -L OUTPUT -n -x --line-numbers | awk '/$3/ { system(\"arptables -D OUTPUT \" \$1); }'"
	fi
### <<<<<<
### >>>>>> Drop arp packets with source address 0.0.0.0 (Macintosh lease muncher)
	arptables -D INPUT --opcode 1 --h-length 6 -s 0.0.0.0 -d $3 -j DROP
	arptables -I INPUT -1 --opcode 1 --h-length 6 -s 0.0.0.0 -d $3 -j DROP
### <<<<<<
	if [ -e /var/run/named.pid ]; then
		kill -HUP `cat /var/run/named.pid`
	fi

	if [ "$NET_LANCATTP" = "on" ]; then
		catnat_dhcprequest $@
	fi

	if [ "$NET_LANMACTP" = "on" ]; then
		macnat_dhcprequest $@
	else if [ "$NET_WANMODE" = "BRIDGE" ]; then
		bridge_dhcprequest $@
	fi
	fi
}

handle_release ( ) {
	logger handle_dhcprelease $1 $2 $3 $4

	if [ "$NET_WANMODE" = "BRIDGE" ]; then
		removeentries $2
	fi

	if [ "$NET_LANSUBNETDIFF" = "on" ]; then
		index=`echo $3 | awk -F \. '/./ { print $3 }'`
		ip=`echo $3 | awk -F \. '/./ { print $1 "." $2 "." $3 ".1" }'`
		ifname=`ifconfig | awk -v ip=$ip '/HWaddr/ { ifname=$1 } /inet addr/ { if (substr($2, 6) == ip) print ifname }'`
		ifconfig $ifname down
	else
		route del -host $3
	fi
	if [ -e /var/run/named.pid ]; then
		kill -HUP `cat /var/run/named.pid`
	fi
}

handle_inform ( ) {
	logger handle_dhcpinform $1 $2 $3 $4
}

if [ "$4" != "eth1" -a "$3" != "eth1" ]; then
	handle_$1 $@
fi

exit 0

--=-4LwezRlim5Hmgzp9y+yx
Content-Disposition: attachment; filename=dhcpd.c
Content-Type: text/x-csrc; name=dhcpd.c; charset=utf-8
Content-Transfer-Encoding: 7bit

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


--=-4LwezRlim5Hmgzp9y+yx--

