From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: Remove references to obsolete
 CONFIG_IP_ROUTE_FWMARK
Date: Thu, 30 Jun 2016 15:59:46 +0200
Message-ID: <20160630135946.GA2499@salvia>
References: <8e3e7f0b-73f7-3cde-509b-79403503c6de@sichert.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Moritz Sichert <moritz+linux@sichert.me>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8e3e7f0b-73f7-3cde-509b-79403503c6de@sichert.me>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Jun 30, 2016 at 11:46:28AM +0200, Moritz Sichert wrote:
> This option was removed in commit 47dcf0cb1005 ("[NET]: Rethink mark field
> in struct flowi").

Applied, thanks.
