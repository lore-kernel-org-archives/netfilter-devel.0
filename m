From: Roberto Nibali <ratz@drugphish.ch>
Subject: Re: [PATCH 2.4] TCP window tracking: nf-log
Date: Sun, 04 Dec 2005 20:38:32 +0100
Message-ID: <439345B8.7000504@drugphish.ch>
References: <43819E46.4020603@tac.ch>
	<20051204135139.GA5570@alpha.home.local>	<4393304C.2030100@drugphish.ch>
	<20051204181236.GA6314@alpha.home.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Willy Tarreau <willy@w.ods.org>
In-Reply-To: <20051204181236.GA6314@alpha.home.local>
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

>>> I've fixed two things which prevented it from compiling :
>>>   - removed a space change in ip_vs_conn.c which might have been caused
>>>     by a change in your reference 2.4.32 tree ;
>> Hmm, I hopefully haven't included IPVS stuff into the nf-log patch, have
>> I? I don't seem to be able to find this change in your proposal.
> 
> Here is the chunk I found in your patch and which I removed :
> 
> diff -Nur linux-2.4.32-orig/net/ipv4/ipvs/ip_vs_conn.c linux-2.4.32-pab2/net/ipv4/ipvs/ip_vs_conn.c
> --- linux-2.4.32-orig/net/ipv4/ipvs/ip_vs_conn.c        2005-10-27 17:17:13 +0200
> +++ linux-2.4.32-pab2/net/ipv4/ipvs/ip_vs_conn.c        2005-10-27 17:17:54 +0200
> @@ -246,7 +246,7 @@
>  struct ip_vs_conn *ip_vs_ct_in_get
>  (int protocol, __u32 s_addr, __u16 s_port, __u32 d_addr, __u16 d_port)
>  {
> -       unsigned hash:
> +       unsigned hash;
>         struct ip_vs_conn *cp;
>  
>         hash = ip_vs_conn_hashkey(protocol, s_addr, s_port);
> 
> Just white spaces, but it was rejected. That's why I believe that your
> reference tree has been touched.

Well, this is more than a whitespace fix, I must have put a colon at
this place while working on my IPVS extension on one drop and later when
compile testing I replaced the erroneous colon with a semicolon. However
I didn't read my patch before sending to netfilter. My bad, thanks for
updating it, Willy. Next time I will proof-read my patches for such
stupid mistakes.

> Nearly ready to boot it :-)

Good luck, if you need kdb patches, I have them ready :).

http://www.drugphish.ch/patches/ratz/kernel/2.4.x/linux-2.4.32-kdb-v4.3-common-1.diff
http://www.drugphish.ch/patches/ratz/kernel/2.4.x/linux-2.4.32-kdb-v4.3-i386-1.diff

Cheers,
Roberto Nibali, ratz
-- 
echo
'[q]sa[ln0=aln256%Pln256/snlbx]sb3135071790101768542287578439snlbxq' | dc
