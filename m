From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] ulogd mysql fix
Date: Wed, 01 Aug 2007 15:06:33 +0200
Message-ID: <46B08559.7040001@netfilter.org>
References: <1185968915.30855.9.camel@khasse.inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <1185968915.30855.9.camel@khasse.inl.fr>
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

Hi Eric,

Eric Leblond wrote:
> MySQL 5.0 has changed the default for database reconnection after
> timeout. It is now not enabled by default. The following patch restores
> the reconnection functionnality for the ulogd-mysql plugin.

Why don't we inconditionally enable it? I mean, we can just forget about
the version checking. If I understood well, mysql <= 5.0 enables
reconnection by default and >= 5.0 doesn't, so we can inconditionally
enable it and forget about future default behaviours. What do you think?

-- 
"Será preciso viajar a través de los ojos de los idiotas" -- Poeta en
Nueva York -- Federico García Lorca.
