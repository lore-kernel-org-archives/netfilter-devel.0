From: Alexandre Becoulet <alexandre.becoulet@epita.fr>
Subject: Re: [new filter] simple packet authentication
Date: Fri, 23 Jan 2004 02:16:08 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200401230216.08607.alexandre.becoulet@epita.fr>
References: <200401222204.04861.alexandre.becoulet@epita.fr> <0de101c3e147$648fa910$2601010a@bluereef.local>
Reply-To: alexandre.becoulet@epita.fr
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <0de101c3e147$648fa910$2601010a@bluereef.local>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Friday 23 January 2004 01:25, Andrew Hall wrote:

> This is a neat idea although I'd probably be a bit wary to use the IP ID
> field when considering it's use with fragments.

Sure, using the IP ID field could be an issue. The module will not mangle 
fragmented packets (offset > 0 or MF flag set). That's why packets have to be 
mangled before being routed. At least, it should work for locally-generated 
packets, and for packets reaching the first gateway. It should not be usefull 
to mangle the packet later.

There is no more problem once the packet has already been mangled because 
fragmentation will duplicate the new IP ID value.

I don't know if a Linux box can locally generate already fragmented IP packets 
when used with a TCP payload and a short MTU.

> Perhaps a better solution
> would be to use part of the options field which apparently DoD originally
> planned to use for this type of IP partitioning.

It could be solution to use the options field but the packet will not appear 
as being a common packet on the wire anymore. I find it nice to have a 
"normal" packet with an hidden authentication information inside ;).

> Also it would be good if
> it was payload agnostic (could be used for UDP as well as TCP).

Yes, it would be great to had support for UDP packets as well. UDP header 
doesn't contain enough varying fields to compute a good hash value for each 
sent packets. I may consider using a part of UDP data to compute the hash 
value...

Regards,

-- 
Alexandre Becoulet
