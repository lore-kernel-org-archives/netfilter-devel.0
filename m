From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables v2] extensions: libip6t_srh: support matching
 previous, next and last SID
Date: Tue, 8 May 2018 14:36:32 +0200
Message-ID: <20180508123632.2wgwnk2d2cax66fq@salvia>
References: <1524652247-1749-1-git-send-email-amsalam20@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fw@strlen.de, davem@davemloft.net, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Ahmed Abdelsalam <amsalam20@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1524652247-1749-1-git-send-email-amsalam20@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Apr 25, 2018 at 05:30:47AM -0500, Ahmed Abdelsalam wrote:
> This patch extends the libip6t_srh shared library to support matching
> previous SID, next SID, and last SID.

Applied, thanks.

Please, send us a patch to add tests for extensions/libip6t_srh.t
