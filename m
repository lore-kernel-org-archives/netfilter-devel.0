From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: ip_conntrack table full problem
Date: Wed, 23 Mar 2005 10:11:38 +0100
Message-ID: <200503231011.38271.thomas.jarosch@intra2net.com>
References: <200503141647.42299.thomas.jarosch@intra2net.com>
	<200503211803.18918.thomas.jarosch@intra2net.com>
	<4240D6BE.8080402@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
To: "netfilter-devel" <netfilter-devel@lists.netfilter.org>
In-Reply-To: <4240D6BE.8080402@trash.net>
Content-Disposition: inline
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

> >>>/proc/slabinfo:
> >>>ip_conntrack       16263  16272    320 1356 1356    1
> >>
> >>Yes, you're leaking conntracks somewhere.  Any possibility of testing
> >>a somewhat newer kernel than 2.4.21?  This may have already been
> >>fixed.
> >
> > Thank you for your response.
> > Unfortunately I cannot update to a newer kernel soon.
>
> I suggest trying this patch:
>
> http://linux.bkbits.net:8080/linux-2.4/cset@3f219dbcj1MnJqxiJa99m_AcShdk5A?
>nav=index.html|src/net/|src/net|src/net/ipv4|src/net/ipv4/netfilter|related/
>net/ipv4/netfilter/ip_conntrack_core.c

Thanks! I'll install a patched kernel on the box today.
Hopefully the problem will vanish...

Thomas
