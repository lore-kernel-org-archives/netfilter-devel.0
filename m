From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: tcp-window-tracking vs. pending/24_conntrack-nosysctl.patch
Date: 05 Apr 2003 17:18:13 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1049555893.25169.193.camel@tux.rsn.bth.se>
References: <Pine.LNX.4.33.0304051645460.21072-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.33.0304051645460.21072-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 2003-04-05 at 16:51, Jozsef Kadlecsik wrote:

> I see what you mean. Strange, the patches I used at the testing did depend
> on each other.
> 
> Then if a patch depends on other patches an any of them isn't applied yet,
> then stop and ask to apply that missing patch immediately. Thus we can
> keep consistency without the need of copying the source trees.
> 
> What do you think?

I think this might be a better solution than my ugly hack that copies
the sourcetree and then doesn't ask the user if he/she/it really wants
to apply the patch. The downside is that if the user wants to install
patch A which requires B which in turn requires C and patch B fails,
then you have a tree which contains C and nothing more. It might be
nicer to the user to not modify anything if something in the
dependency-chain fails.

-- 
/Martin
