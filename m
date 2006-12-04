From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables 1.3.6 compilation issues in libipt_iprange.c
 (non-existant __be32 type)
Date: Mon, 04 Dec 2006 17:02:08 +0100
Message-ID: <45744680.5080702@trash.net>
References: <20061204154845.GA21750@ekonomika.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	kulnet@kulnet.kuleuven.be
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Steven Van Acker <deepstar+NRpGDEuW@singularity.be>
In-Reply-To: <20061204154845.GA21750@ekonomika.be>
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

Steven Van Acker wrote:
> Hi,
> 
> iptables 1.3.6 does not compile with the 2.6.19 kernel
> because an undefined type __be32 is used in libipt_iprange.c
> 
> Apparently, a fix was issued before, which can be found here:
> http://lists.netfilter.org/pipermail/netfilter/2006-October/066954.html
> 
> Before I started looking for a patch, I wrote one myself
> and it's a bit different from the one found at the location mentioned
> above.
> 
> Instead of #defining the __be32 type "manually", you could also #include
> <linux/types.h>, which defines that datatype.
> 
> I'm not sure if it's a good idea to duplicate definitions of datatypes
> in iptables. Is there a purpose I'm overlooking ?
> 
> Is it also possible to mention the fix for the __be32 issue on
> netfilter.org ? I'm sure more people will run into it as 2.6.19 is going
> mainstream, and we don't all use the SVN repository to compile iptables
> :)

I've already uploaded a 1.3.7 release to ftp.netfilter.org to fix this
issue (please test :), once the webpage has been updated I'll send out
the announcement.
