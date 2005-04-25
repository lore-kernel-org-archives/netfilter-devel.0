From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [NETFILTER]: Fix NAT sequence number adjustment
Date: Sun, 24 Apr 2005 18:42:03 -0700
Message-ID: <20050424184203.124aadac.davem@davemloft.net>
References: <42682F74.9030203@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42682F74.9030203@trash.net>
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

On Fri, 22 Apr 2005 00:55:48 +0200
Patrick McHardy <kaber@trash.net> wrote:

> another important fix which should go in 2.6.12 if possible.
> NAT sequence number adjustment is broken since 2.6.11, quite
> a few people have reported failing and corrupted FTP control
> connections.

Applied, thanks Patrick.
