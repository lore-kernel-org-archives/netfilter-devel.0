From: Primantara HT <prim@csse.uwa.edu.au>
Subject: Additional Option that is nout used
Date: Thu, 5 Sep 2002 12:19:53 +0800 (WST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0209051214570.8188-100000@server01.cs.uwa.edu.au>
References: <20020324150524.GA31340@endlich.mbsi.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.samba.org
In-Reply-To: <20020324150524.GA31340@endlich.mbsi.ca>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Dear,

I found an additional option in line 1690 of iptables.c.
This option is "M:" that is not used in options described in
previous part of the iptables.c or for "case()"

The line contains :
 "-A:D:R:I:L::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvnt:m:xc:",
              ^^
	      ^^

Thank's

Prim
