From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: ip_conntrack table full problem
Date: Tue, 29 Mar 2005 22:26:42 +0200
Message-ID: <200503292226.42570.thomas.jarosch@intra2net.com>
References: <200503141647.42299.thomas.jarosch@intra2net.com>
	<200503211803.18918.thomas.jarosch@intra2net.com>
	<4240D6BE.8080402@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
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

Hi Patrick,

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

That patch solved the problem. Thanks!

I'm curious how this bug is triggered in real-life usage?

Cheers,
Thomas
