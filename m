From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: Re: Header Matching
Date: Tue, 24 Jun 2003 12:09:14 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.51.0306241207290.30455@dns.toxicfilms.tv>
References: <20030624091119.GC2532@flaptop.xsinet.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick <patrick@xsinet.co.za>
In-Reply-To: <20030624091119.GC2532@flaptop.xsinet.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> i would like to match the PREC= value ?
Look for FTOS match and target. They are deprecated now, but they are in
patch-o-matic/obsolete/

Regards,
Maciej
