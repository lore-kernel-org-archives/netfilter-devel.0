From: Patrick McHardy <kaber@trash.net>
Subject: Re: Question: Variable sized matchinfo
Date: Tue, 21 Jan 2003 12:42:16 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E2D3218.1040805@trash.net>
References: <20030120232634.24011.21218.Mailman@kashyyyk> <15916.60267.562015.732567@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Don Cohen <don-netf@isis.cs3-inc.com>
In-Reply-To: <15916.60267.562015.732567@isis.cs3-inc.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Don Cohen wrote:

> > I want to write a match where it would be nice to pass a variable sized 
> > matchinfo to kernelspace.
>The answer when I asked this question in connection with u32 was no.
>In fact,
>I asked:
>  > Would it work to make that 10 into a module parm (or three) ?
>Harald answered:
>  unfortunately not.  The size of this structure needs to be known at
>  compile time of the kernel and iptables userspace (and they have to be
>  the same, obviously).
>

Oops, i probably missed that.
Anyway this doesn't seem to be real problem, you could just pass pointers
and copy_from_user the data. The probleme there is the match is not informed
if its not needed anymore, so no chance to free the memory.

>
> > Is this possible ? I want to avoid always using the largest possible 
> > values (2^16 + a few bytes).
> > The data in question is a bpf program compiled with pcap_compile ..
> > This is probably not the most useful match but i think it beats u32 
> > because bpf syntax is already well-known
> > and very pleasant to use.
>Thanks for the reference.  I'll read about it.  I assume you mean the
>u32 I posted recently.
>So far the bpf language doesn't strike me as pleasant to use compared
>to the small language I made up for u32, but maybe that's just cause
>I'm not used to it.  
>I gather 2^16 is the maximum possible size of a bpf program.
>

no they are not limited in size AFAIK. I recently portet PPP_FILTERs to 
isdn and
they chose a limit of 2^16 which sounds sane. But i missed its not 2^16 
bytes
but 2^16 * sizeof(struct sock_fprog). If you want to look at a example 
for using
sk_run_filter (matches bpf code in kernel) you can look at it at 
http://trash.net/~kaber

>How about supplying several different variants of your module,
>one that has data size 128 bytes, another with size 1K, another 8K
>and finally 64K.
>  
>

no i decided its too ugly to do stuff like this without beeing able to 
either pass a variable-sized
struct from userspace (the size-check is done by the module itself, so 
no problem there) or allocate
the memory in kernelspace myself (and free it afterwards). Both doesn't 
seem like a big problem to do,
but it's not worth it for a just-for-fun match. Another uglyness is it 
is not possible to display the bpf
code in userspace with iptables -L because its already compiled and 
optimized. IIRC you ran into the same
problem with u32.
If anyone would really like a bpf match tell me and i might reconsider.

Patrick
