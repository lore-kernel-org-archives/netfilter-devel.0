From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables-compat: homogenize error message
Date: Tue, 29 May 2018 00:04:35 +0200
Message-ID: <20180528220435.rzd4lahsa25h2xe7@salvia>
References: <20180527130901.GA18320@seema-Inspiron-15-3567>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: Arushi Singhal <arushisinghal19971997@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180527130901.GA18320@seema-Inspiron-15-3567>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Sun, May 27, 2018 at 06:39:01PM +0530, Arushi Singhal wrote:
> There is a difference between error messages in iptables and
> iptables-compat:
> 
> #sudo iptables-compat -D INPUT 4
> iptables: No chain/target/match by that name.
> 
> #sudo iptables -D INPUT 4
> iptables: Index of deletion too big.
> 
> Now, will show same error message.

Applied, thanks Arushi.

P.S: Just Cc: netfilter-devel@vger.kernel.org next time. Thanks.
