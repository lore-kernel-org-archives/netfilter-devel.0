From: Netfilter Core Team <coreteam@netfilter.org>
Subject: Re: Release of iptables-1.3.7
Date: Wed, 06 Dec 2006 10:54:02 +0100
Message-ID: <4576933A.7080006@netfilter.org>
References: <45769244.3060508@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050605090806010602070101"
Cc: lwn@lwn.net
Return-path: <netfilter-announce-bounces@lists.netfilter.org>
To: netfilter-announce@lists.netfilter.org,
	netfilter@lists.netfilter.org,  netfilter-devel@lists.netfilter.org
In-Reply-To: <45769244.3060508@netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-announce>,
	<mailto:netfilter-announce-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-announce>
List-Post: <mailto:netfilter-announce@lists.netfilter.org>
List-Help: <mailto:netfilter-announce-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-announce>,
	<mailto:netfilter-announce-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-announce-bounces@lists.netfilter.org
Errors-To: netfilter-announce-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------050605090806010602070101
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Netfilter Core Team wrote:
> Hi!
> 
> The netfilter coreteam proudly presents:
> 
> 	iptables version 1.3.7
> 
> The 1.3.7 version contains accumulated bugfixes to the last 1.3.6
> version. This comes a bit earlier after the last release than
> usual because the endian annotations in 2.6.19 broke iptables
> compilation, which is fixed with this version.
> 
> The ChangeLog is attached to this mail.

It should have been at least :)



--------------050605090806010602070101
Content-Type: text/plain;
 name="changes-iptables-1.3.7.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="changes-iptables-1.3.7.txt"

Bugs fixed since 1.3.6:

- Fix compilation error with linux 2.6.19
  [ Patrick McHardy ]

- Fix LOG target segfault with --log-prefix ""
  [ Mike Frysinger, Bugzilla #516 ]

- Fix conflicting getsockopt optname values for IP6T_SO_GET_REVISION_{MATCH,TARGET}
  [ Yasuyuki KOZAKAI ]

- Fix -E (rename) in iptables/ip6tables
  [ Krzysztof Piotr Oledzki ]

- Fix /etc/network usage
  [ Pablo Neira ]

- Fix iptables-save not printing -s/-d ! 0/0
  [ Patrick McHardy ]

- Fix ip6tables-save unnecessarily printing -s/-d options for zero prefix length
  [ Daniel De Graaf ]

New features since 1.3.6:

- Add revision support for ip6tables
  [ R?mi Denis-Courmont ]

- Add port range support for ip6tables multiport match
  [ R?mi Denis-Courmont ]

- Add sctp match extension for ip6tables
  [ Patrick McHardy ]

- Add iptables-xml tool
  [ Amin Azez ]

- Add hashlimit support for ip6tables (needs kernel > 2.6.19)
  [ Patrick McHardy ]

- Use /lib/modules/$(shell uname -r)/build instead of /usr/src/linux to look for kernel source
  [ Patrick McHardy ]

- Add NFLOG target extension for iptables/ip6tables (needs kernel > 2.6.19)
  [ Patrick McHardy ]


--------------050605090806010602070101--
