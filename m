From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: 2.6.20: ipt_owner match and INPUT chain
Date: Thu, 15 Mar 2007 18:04:21 +0100
Message-ID: <200703151804.21980.thomas.jarosch@intra2net.com>
References: <200703020946.20765.thomas.jarosch@intra2net.com>
	<45F04F6F.5020103@trash.net>
	<200703091138.57392.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_VyX+FC52HTK+Rel"
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200703091138.57392.thomas.jarosch@intra2net.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

--Boundary-00=_VyX+FC52HTK+Rel
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello Patrick,

On Friday, 9. March 2007, Thomas Jarosch wrote:
> > Without having looked into this in detail, I guess it should be
> > in the tens of minutes range. We need this anyway for state
> > synchronization since the H.323 helper manually assigns
> > unregistered helpers to its children.
>
> Do expectations always need an associated conntrack entry
> or could they be added as orphans? I can imagine it will be
> quite difficult for the shell script to find
> the correct client<->socks server conntrack.

In the meantime I've developed a small patch for the dante socks server
which I post here so anyone facing the same problem
has a starting point for a solution.

Also finding the conntrack via a shell script shouldn't be too hard at all
as the socks server knows the client ip/src port and the IP/port on the 
server. That should be enough to grep for the conntrack.

Could you take a shot at the helperless expectation, please?
I would happily test it :-)

Cheers,
Thomas

--Boundary-00=_VyX+FC52HTK+Rel
Content-Type: text/x-diff; charset="iso-8859-15"; name="dante-firewall.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dante-firewall.patch"

diff -u -r -p dante-1.1.19/sockd/sockd_request.c dante.socks/sockd/sockd_request.c
--- dante-1.1.19/sockd/sockd_request.c	Sat Jan  7 19:54:47 2006
+++ dante.socks/sockd/sockd_request.c	Thu Mar 15 16:32:53 2007
@@ -250,6 +250,10 @@ dorequest(mother, request)
 	char msg[256];
 	int failed, p, permit, out, failurecode = SOCKS_NOTALLOWED;
 
+	// Used by the firewall patch
+	int i, firewall_open = 0;
+	uid_t euid;
+
 	slog(LOG_DEBUG, "received request: %s",
 	socks_packet2string(&request->req, SOCKS_REQUEST));
 
@@ -841,6 +845,26 @@ dorequest(mother, request)
 			emfile = 0;
 			iolist = NULL;
 
+			// is bind request on external IP?
+		    	for (i = 0; i < sockscf.external.addrc; ++i) {
+			    if (sockscf.external.addrv[i].addr.ipv4.ip.s_addr == response.host.addr.ipv4.s_addr) {
+    				slog(LOG_DEBUG, "Firewall open: dst %s:%d", inet_ntoa(response.host.addr.ipv4), ntohs(response.host.port));
+				slog(LOG_DEBUG, "Firewall open: src %s:%d", inet_ntoa(io.src.host.addr.ipv4), ntohs(io.src.host.port));
+
+				// protocol
+				if (io.state.protocol == SOCKS_UDP)
+    				    slog(LOG_DEBUG, "Firewall open: protocol UDP");
+				else
+    				    slog(LOG_DEBUG, "Firewall open: protocol TCP");
+
+				// socks_seteuid(&euid, sockscf.uid.privileged);
+				firewall_open = 1;
+				// socks_reseteuid(sockscf.uid.privileged, euid);
+
+				break;
+			    }
+			}
+
 			/* CONSTCOND */
 			/* keep accepting connections until 
 			 * a) we get a remote address that matches what client asked for.
@@ -1200,6 +1224,15 @@ dorequest(mother, request)
 			}
 
 			closev(sv, ELEMENTS(sv));
+
+                        /* TOMJ: If expectation is related to conntrack entry
+                                 this code is not needed */
+		    	if (firewall_open == 1) {
+                           // Delete firewall rule
+			    // socks_seteuid(&euid, sockscf.uid.privileged);
+			    // socks_reseteuid(sockscf.uid.privileged, euid);
+			    firewall_open = 0;
+			}
 			break;
 		}
 

--Boundary-00=_VyX+FC52HTK+Rel--
