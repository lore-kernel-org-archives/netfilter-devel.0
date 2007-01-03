From: Patrick McHardy <kaber@trash.net>
Subject: Re: [BUG] panic 2.6.20-rc3 in nf_conntrack
Date: Wed, 03 Jan 2007 21:44:55 +0100
Message-ID: <459C15C7.4080000@trash.net>
References: <200701020228_MC3-1-D707-115D@compuserve.com> <Pine.LNX.4.58.0701030913470.8163@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Chuck Ebbert <76306.1226@compuserve.com>,
	"MalteSch@gmx.de" <MalteSch@gmx.de>, linux-kernel@vger.kernel.org,
	berni@birkenwald.de, netfilter-devel@lists.netfilter.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932099AbXACUpH@vger.kernel.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <Pine.LNX.4.58.0701030913470.8163@tux.rsn.bth.se>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Martin Josefsson wrote:
> Check the return value of nfct_nat() in device_cmp(), we might very well
> have non NAT conntrack entries as well.
> 
> Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>

Applied, thanks Martin.
