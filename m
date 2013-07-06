From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: conntrackd segfault on EPSV IPv6 ftp command when using ftp
 ExpectationSync
Date: Sat, 6 Jul 2013 15:23:33 +0200
Message-ID: <20130706132333.GA3279@localhost>
References: <20130705020312.25783ccd.billfink@mindspring.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org,
	fw@strlen.de
To: Bill Fink <billfink@mindspring.com>
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130705020312.25783ccd.billfink@mindspring.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

On Fri, Jul 05, 2013 at 02:03:12AM -0400, Bill Fink wrote:
> [not sure whether to send to netfilter or netfilter-devel,
> so sending to both, but trim replies as appropriate]
> 
> I am trying to use the ftp ExpectationSync capability of conntrackd
> for both IPv4 and IPv6 for connections through a pair of bridged
> firewalls (primary / hot backup).  I have the following config
> snippet in conntrackd.conf:
> 
> 	Options {
> 		ExpectationSync {
> 			ftp
> 			sip
> 			ras	# for H.323
> 			q.931	# for H.323
> 			h.245	# for H.323
> 		}
> 	}
> 
> For IPv4, things work as expected.  But when I try the basic
> analogous IPv6 test to the suggested IPv4 test from the
> documentation:
> 
> x100ssd2% nc 2001:xxxx:xxxx:xxxx:xxxx:xxxx:xxxx:xxxx 21
> 220 FTP Server ready.
> USER anonymous
> 331 Anonymous login ok, send your complete email address as your password
> PASS bill@
> 230-
>                 *** Welcome to this anonymous ftp server! ***
>  
>      You are user 1 out of a maximum of 10 authorized anonymous logins.
>      The current time here is Thu Jul 04 23:40:51 2013.
>      If you experience any problems here, contact : root@localhost
>  
>  
> 230 Anonymous login ok, restrictions apply.
> EPSV
> 229 Entering Extended Passive Mode (|||1584|)
> 
> As soon as I enter the EPSV command, I get the following
> conntrackd segfault:
> 
> Jul  5 00:41:06 sen-fw1 kernel: [274422.060695] conntrackd[4821]: segfault at 0 ip 000000000040c660 sp 00007fffebb098a8 error 4 in conntrackd[400000+3d000]

I have pushed this patch to fix this issue.

http://git.netfilter.org/conntrack-tools/commit/?id=479a37a549abf197ce59a4ae1666d8cba80fe977

Thanks Florian for diagnosing this, and you for reporting.

> I am using a Fedora 17 3.7.3-101.fc17.x86_64 kernel with
> conntrack-tools-1.4.0-1.fc17.x86_64.
> 
> I had to use the attached patch to get "conntrackd -R" to resync
> both IPv4 and IPv6 (enabled with a "Family IPv4-IPv6" entry in
> conntrackd.conf).  It works well for me for the basic ct table,
> but I'm not sure about the expect table part since I can't really
> exercise it due to the segfault.  Note the segfault also occurs
> with the original unpatched conntrackd, so it's not related to
> my patch.

For this, I have applied the following patch:

http://git.netfilter.org/conntrack-tools/commit/?id=e2c6576e775652c35d336afa0551676339c6a793

Let me know.
