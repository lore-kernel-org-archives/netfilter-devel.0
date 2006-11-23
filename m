From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Update SNMP basic for full IP address NAT
Date: Thu, 23 Nov 2006 17:15:36 +0100
Message-ID: <4565C928.4030504@trash.net>
References: <3418F3471F1CA4409901547349FFAE2E05A05077@FTRDMEL2.rd.francetele		com.fr>
	<455AB76C.9050603@trash.net> <455C7E46.6080404@orange-ftgroup.com>
	<4565A6CC.1090404@trash.net> <4565C7A9.1040500@orange-ftgroup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Gilles Kerdoncuff <gkerdoncuff.ext@orange-ftgroup.com>
In-Reply-To: <4565C7A9.1040500@orange-ftgroup.com>
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

Gilles Kerdoncuff wrote:
> This makes things clear. This is one of those little/big endian problems :
> I'm using this module on a MIPS platform, you probably tested it on an
> Intel architecture
> 
> If you look at ip_conntrack_ftp.c, it uses ntohl routine when extracting
> the tuple IP. This is the way it should be done.
> 
> In the SNMP module, add ntohl after the
>    map.to = NOCT1(
> and
>    map.from = NOCT1(
> code lines
> Run your quick test again, you will see that the bug is there !
> 
> I will fix that in my updated patch.

Please send a seperate patch for this since its unrelated to
your changes.

> Ok, I'll do so as soon as I can find a few hours to code and test it.
> Thanks a lot.

Please make sure you do your patch on top of the nf_nat tree
(http://people.netfilter.org/~kaber/nf-2.6.20-nat.git/) and
update both the old and the new helper. The mail I just sent
to netfilter-devel explains how to clone that tree.
