From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: /proc/net/ip_conntrack
Date: Wed, 30 Jun 2004 18:32:23 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0406301831470.12023-100000@filer.marasystems.com>
References: <40E2C206.1070302@eurodev.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: =?ISO-8859-1?Q?Daniel_Corr=EAa_de_Azevedo?= <nielca@linkexpress.com.br>,
   Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <40E2C206.1070302@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 30 Jun 2004, Pablo Neira wrote:

> >   Any way, what do you think about this? Does it sound like nonsense (I've just my first 
> >contact with LKM...) or it maybe possible? 
> 
> you should forget your thoughts about the /proc interface and start 
> understanding some ip_conntrack internal to replicate the information to 
> some backup's machines.

Or even better yet look into the already ongoing project implementing such 
interface to conntrack.

Regards
Henrik
