From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH] Passive OS fingerprint matching module update. Dynamic
 fingerprint loading.
Date: Tue, 23 Sep 2003 15:59:44 +0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030923155944.521d6299.johnpol@2ka.mipt.ru>
References: <20030922171921.009b2133.johnpol@2ka.mipt.ru>
Reply-To: johnpol@2ka.mipt.ru
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, laforge@netfilter.org,
   quaker@ondraszek.eu.org, solt@dns.toxicfilms.tv
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: johnpol@2ka.mipt.ru
In-Reply-To: <20030922171921.009b2133.johnpol@2ka.mipt.ru>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 22 Sep 2003 17:19:21 +0400
Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:

> This patch also adds possibility to dynamically load fingerprints(for
> complete list of supported fingerprints please see
> http://www.openbsd.org/cgi-bin/cvsweb/src/etc/pf.os and
> http://lcamtuf.coredump.cx/p0f.shtml) through /proc interface.

Btw, Linux rule parsing code is not compatible with OpenBSD one, since
they use fields "version" and "subversion", but one can easily remove
two ":" symbols between them( and details field) and successfully load
new rule. 

> Examples:
> loading new rule:
> echo "16384:64:0:44:M512:.:AIX:4.3.2 and
> earlier">/proc/sys/net/ipv4/osf 

So, in OpenBSD we have: 
16384:64:0:44:M512:             AIX:4.3:2-3:AIX 4.3.2 and earlier
                                                             ^^^^^^^^

If someone like to use this notation, i can create a patch.

	Evgeniy Polyakov
