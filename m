From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] priv_data 0/2
Date: Tue, 04 Jul 2006 02:20:40 +0200
Message-ID: <44A9B458.1030106@trash.net>
References: <200606261641.47294.max@nucleus.it>
	<44A962DF.3080406@trash.net>	<200607032305.06581.max@nucleus.it>
	<44A9A103.8090705@anduras.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Sven Anders <anders@anduras.de>
In-Reply-To: <44A9A103.8090705@anduras.de>
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

Sven Anders wrote:
> If this is merged, I would like to see a negated limit...
> I need some advice to preserve compatibility here.

Once this is merged we can convert matches and targets to keep their
private state outside of the structure shared with userspace and can
start reusing the fields, since they are ignored by userspace anyway.
I'm not sure, but I think currently userspace initializes them to 0,
which should make this easy.
