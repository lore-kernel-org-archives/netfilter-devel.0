From: Willy Tarreau <willy@w.ods.org>
Subject: Re: /proc/net/ip_conntrack permissions
Date: Wed, 2 Jun 2004 07:17:31 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040602051731.GB18783@alpha.home.local>
References: <40BD37D9.5020704@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <40BD37D9.5020704@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Patrick,

On Wed, Jun 02, 2004 at 04:13:45AM +0200, Patrick McHardy wrote:
> I've added a patch to change /proc/net/ip_conntrack permissions
> to 0440. It contains privileged information and shouldn't be
> world readable. I was just wondering why this hasn't been done
> before, does anyone know a good reason not to change it ?

Strange, but I too think it should be restricted, since it's a source of
easy DoS : "while true; do wc -l /p/n/ip_ct ; done" :-/

Regards,
Willy
