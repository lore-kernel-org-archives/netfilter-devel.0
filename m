From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: target, match and checkentry functions
Date: Wed, 28 Apr 2004 15:00:49 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200404281500.49188.thomas.jarosch@intra2net.com>
References: <408F7388.5010704@aiqa.com> <408FAA24.9070707@aiqa.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <408FAA24.9070707@aiqa.com>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> ....also I can not find where LABEL_ACCEPT is defined. I grep`ed all
> kernel and iptables source but could not find! ( It is used in libiptc.c )
>
> thanks to anyone who replies,

libipt4tc.c defines LABEL_ACCEPT as IPTC_LABEL_ACCEPT
if I'm not mistaken. IPTC_LABEL_ACCEPT is defined in libiptc.h

Thomas
