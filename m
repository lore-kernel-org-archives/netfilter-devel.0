From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: HOPLIMIT
Date: Mon, 16 Feb 2004 13:23:04 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402161319410.13183-100000@filer.marasystems.com>
References: <006801c3f482$5f28a190$0e25fe96@pysiak>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
In-Reply-To: <006801c3f482$5f28a190$0e25fe96@pysiak>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 16 Feb 2004, Maciej Soltysiak wrote:

> Hmm, what kernel is that ? Which version and is it
> a vanilla or a distro kernel?
> 
> I wrote the modules as *_HL everywhere and I do not
> recall changing their names ever :-)

Looks like the files are partially renamed in patch-o-matic-ng.

The patch name, Makefile.ldadd and #include refers to HOPLIMIT while the 
files are named HL

Regards
Henrik
