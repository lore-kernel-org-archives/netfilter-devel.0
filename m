From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nf_defrag_ipv4: Drop redundant
 ip_send_check()
Date: Tue, 1 Mar 2016 20:42:26 +0100
Message-ID: <20160301194225.GA2815@salvia>
References: <1454522410-24976-1-git-send-email-joe@ovn.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org, edjee@google.com, edumazet@google.com
To: Joe Stringer <joe@ovn.org>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1454522410-24976-1-git-send-email-joe@ovn.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Feb 03, 2016 at 10:00:10AM -0800, Joe Stringer wrote:
> Since commit 0848f6428ba3 ("inet: frags: fix defragmented packet's IP
> header for af_packet"), ip_send_check() would be called twice for
> defragmentation that occurs from netfilter ipv4 defrag hooks. Remove the
> extra call.

Applied, thanks Joe.
