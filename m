From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Multiple matches of the same type
Date: Sat, 04 Mar 2006 10:37:51 +0100
Message-ID: <44095FEF.7040901@trash.net>
References: <Pine.LNX.4.58.0602270933130.15955@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0602270933130.15955@blackhole.kfki.hu>
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

Jozsef Kadlecsik wrote:
> Hi,
> 
> The attached patch adds the ability to specify multiple matches of the
> same type by ip[6]tables. Besides removing a limitation, a few matches
> (recent, u32, set :-) can benefit from the feature.
> 
> If two or more matches of the same type are detected then the options are
> assumed to be grouped in order to tell which option belongs to which
> match:
> 
> ... -m foo ... <options0> ... -m foo ... <options1> ...
> 

I think thats a reasonable assumption. Its good to finally get rid of
this limitation.
