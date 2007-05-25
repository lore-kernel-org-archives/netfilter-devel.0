From: "YU\, Haitao" <yuhaitao@tsinghua.org.cn>
Subject: Re: bugs in ftp conntrack
Date: Fri, 25 May 2007 09:10:57 +0800
Message-ID: <380055457.11873@tsinghua.org.cn>
Reply-To: "YU, Haitao" <yuhaitao@tsinghua.org.cn>
Content-Type: text/plain
Cc: netfilter-devel@lists.netfilter.org
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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



In your mail:
>From: Patrick McHardy <kaber@trash.net>
>Reply-To: 
>To: "YU, Haitao" <yuhaitao@tsinghua.org.cn>
>Subject: Re: bugs in ftp conntrack
>Date:Thu, 24 May 2007 20:16:05 +0200
>
>
>There's not much we can do about this case, we already keep a history
>of sequence numbers. As you note below that code is pretty broken
>currently, but I have patches queued to fix it (attached to this mail).
>


I think if it's possible that we don't record the new seqence of too new packets.
"Too new packets" means the sequence of the packet is greater than all
seq_aft_nl[] values.  We just wait until another "port", "227", etc. packet is
parsed correctly.


So the return value of function find_nl_seq() shoule be three: 
1: too new, then parse pattern, only if found > 0,  then update seq, else keep
current seq_aft_nl;
0: match one of the remembered seq, then parse pattern, update seq when found >=
0;
-1: too old(less than all remembered seq),  just goto out, (not goto
out_update_nl)


Thanks,

YU, Haitao
