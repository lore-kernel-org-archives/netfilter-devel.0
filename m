From: "Feldman, Scott" <scott.feldman@intel.com>
Subject: RE: Extremely slow network with e1000 & ip_conntrack
Date: Wed, 3 Dec 2003 23:24:24 -0800
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <C6F5CF431189FA4CBAEC9E7DD5441E0102CBDD20@orsmsx402.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: <netfilter-devel@lists.netfilter.org>,
	<linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
content-class: urn:content-classes:message
To: "Harald Welte" <laforge@netfilter.org>,
	"Stephen Lee" <mukansai@emailplus.org>
List-Id: netfilter-devel.vger.kernel.org

> > > > 2.4.22		82540EM		N
> > > > 2.5.26		82540EM		N
> > > > 2.5.46		82540EM		Y
> > > > 2.6.0-test10		82540EM		Y
> > > > 2.6.0-test11		82540EM		Y
> > > > 2.6.0-test11		82547EI		N
> > > > 2.4.22nptlsmp		82547EI		N
> 
> In e1000, check this out:
> 
>   #ifdef NETIF_F_TSO
>           if((adapter->hw.mac_type >= e1000_82544) &&
>              (adapter->hw.mac_type != e1000_82547))
>                   netdev->features |= NETIF_F_TSO;
>   #endif

Oh, I forgot one thing: 82540 is actually greater than 82544.  The
comparison is chronological order, not numerical.  This is the order the
controllers where released:

82542
82543
82544
82540
82545
82546
82541
82547

Don't ask.

-scott
