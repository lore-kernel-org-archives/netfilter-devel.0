From: Eric Leblond <eric@inl.fr>
Subject: Re: only first TCP SYN packet consulted in nat table chains - bug
	or feature?
Date: Tue, 22 Jun 2004 15:33:54 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1087911233.7536.2.camel@coati>
References: <Pine.LNX.4.44.0406221516540.21321-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.44.0406221516540.21321-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 2004-06-22 at 15:19, Henrik Nordstrom wrote:
> On Mon, 21 Jun 2004, Krzysztof Rusocki wrote:
> 
> If you need to remember something related to a specific session between
> packets then see the CONNMARK patch in pom-ng.

This extension is one more time useful to someone. Does somebody know
why it has not been included into the standard kernel ?

BR,
-- 
Eric Leblond <eric@inl.fr>
INL
