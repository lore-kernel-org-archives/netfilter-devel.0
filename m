From: "zhengchuanbo" <zhengcb@netpower.com.cn>
Subject: Re: Re: can tcp stream reassembly be done in netfilter
Date: Mon, 1 Sep 2003 11:39:25 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030901112993.SM00856@zhengcb>
Mime-Version: 1.0
Content-Type: text/plain;
      charset="GB2312"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
 Oskar Andreasson <blueflux@koffein.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


	I just downloaded the libqsearch. It's great that it can do the stream reassembly.
	Is there any examples on its application in linux kernel? or do you think it can
do filter the tcp stream in netfilter?
	thanks.

Jack zheng
zhengcb@netpower.com.cn
	
>On Wed, Aug 27, 2003 at 10:35:10AM +0200, Oskar Andreasson wrote:
>> On Tue, 26 Aug 2003, zhengchuanbo wrote:
>> 
>> > 	Can netfilter do the tcp stream reassembly? I mean something like
>> > what snort do in the stream process. I wish this could be done in the
>> > kernel.
>> 
>> No, netfilter is a packet filter. It works on a per packet basis, below
>> the transport layer. Actually it does do some work on the transport layer,
>> but not much, and definitely not a lot of work on the application layers.
>> 
>> All of this comes down to one thing, netfilter simply doesnt care about
>> streams. That's when you should use snort or proxy solutions of one sort
>> or another.
>
>Thanks for this excellent reply.  
>
>I have to add that there is a project for linux kernel stream reassembly
>and pattern-matching:  libqsearch.  Try google :)
>
>-- 
>- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
>============================================================================
>  "Fragmentation is like classful addressing -- an interesting early
>   architectural error that shows how much experimentation was going
>   on while IP was being designed."                    -- Paul Vixie
>-----BEGIN PGP SIGNATURE-----
>Version: GnuPG v1.2.2 (GNU/Linux)
>
>iD8DBQE/UPWlXaXGVTD0i/8RAvoPAKCNvzD4pLnyUcxL6y/08GU8cfvULQCfYPxF
>fhHZTP+r1gkBSaEv3iDodH8=
>=BQg0
>-----END PGP SIGNATURE-----

= = = = = = = = = = = = = = = = = = = =
			
