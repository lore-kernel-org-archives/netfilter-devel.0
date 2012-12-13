From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Formal submission of Xtables2
Date: Thu, 13 Dec 2012 12:00:46 +0100
Message-ID: <20121213110046.GA22337@1984>
References: <alpine.LNX.2.01.1212130601210.9421@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Netfilter user mailing list <netfilter@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1212130601210.9421@nerf07.vanv.qr>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Dec 13, 2012 at 07:00:07AM +0100, Jan Engelhardt wrote:
[...]
> Please consider for merging.

nftables and its compatibility layer already provide this and we will
not have to maintain two different netlink interfaces, which is too
much overhead.
