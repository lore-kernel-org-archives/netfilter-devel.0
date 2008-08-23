From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
Subject: Re: [PATCH] tcp FRTO: in-order-only "TCP proxy" fragility workaround
Date: Sat, 23 Aug 2008 17:38:32 +0300 (EEST)
Message-ID: <Pine.LNX.4.64.0808231736490.10712@wrl-59.cs.helsinki.fi>
References: <20080819213417.45133573@tux> <Pine.LNX.4.64.0808201358490.4551@wrl-59.cs.helsinki.fi>
 <20080822183224.2d52f16c@tux> <20080822.143709.65615512.davem@davemloft.net>
 <20080823111446.06a350a2@tux>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-696208474-49703739-1219502312=:10712"
Cc: David Miller <davem@davemloft.net>, thomas.jarosch@intra2net.com,
	billfink@mindspring.com, Netdev <netdev@vger.kernel.org>,
	Patrick Hardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org, kadlec@blackhole.kfki.hu
To: "=?ISO-8859-1?Q?D=E2niel?= Fraga" <fragabr@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20080823111446.06a350a2@tux>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---696208474-49703739-1219502312=:10712
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Sat, 23 Aug 2008, Dâniel Fraga wrote:

> On Fri, 22 Aug 2008 14:37:09 -0700 (PDT)
> David Miller <davem@davemloft.net> wrote:
> 
> > Yes, but it's important that you verify that the patch makes the
> > problem go away when HTB is enabled.  Please make this test if you
> > can.
> 
> 	Correct! I tested with the HTB patches and the problem was
> solved. ;) Thank you very much.

Thanks for verifying it!

-- 
 i.
---696208474-49703739-1219502312=:10712--
