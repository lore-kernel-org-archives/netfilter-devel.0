From: "David S. Miller" <davem@davemloft.net>
Subject: Re: ipsec implementation using netfilter
Date: Fri, 18 Mar 2005 23:10:05 -0800
Message-ID: <20050318231005.29ed2120.davem@davemloft.net>
References: <20050319065622.45027.qmail@web31402.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: avinash m <kukzme@yahoo.com>
In-Reply-To: <20050319065622.45027.qmail@web31402.mail.mud.yahoo.com>
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

On Fri, 18 Mar 2005 22:56:21 -0800 (PST)
avinash m <kukzme@yahoo.com> wrote:

> I have seen the openswan.org but that didnt get me
> anywhere. I am also not clear hoe i could place this
> customization into the existing ipsec stack(if i could
> understand that)

People have written experimental patches that allow
hw acceleration of IPSEC using the existing IPSEC stack.
It's actually not very difficult.

See the netdev@oss.sgi.com archives for details.

Using netfilter is the last way you would go about doing
this.
