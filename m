From: "Ryan W. Maple" <ryan@guardiandigital.com>
Subject: PPTP conntrack/NAT Problems
Date: Wed, 25 Feb 2004 15:51:40 -0500 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.58.0402251550120.12632@mastermind.inside.guardiandigital.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


I've been searching high and low for the 1.13 "version" of the PPTP
helpers referred to in this message:

  http://marc.theaimsgroup.com/?l=netfilter-devel&m=106426344328158&w=4

I cannot find it _anywhere_.  The latest POM has revisions 1.9 (conntrack)
and 1.5 (nat) while the netfilter-extensions repository has 1.10/1.6.
Could somebody please tell me exactly which of these (if either) are
"version 1.13"?

We're having a very hard time trying to NAT outbound PPTP connections
_and_ accept incoming PPTP connections on the same box -- an issue that it
appears was fixed in this version.  However it still does not seem to work
on 1.10/1.6 so I'm hoping there is a more recent version somewhere that
I'm just not seeing.

Thank you very much,
Ryan

 +-- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --+
   Ryan W. Maple          "I dunno, I dream in Perl sometimes..."  -LW
   Guardian Digital, Inc.                     ryan@guardiandigital.com
 +-- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --+
