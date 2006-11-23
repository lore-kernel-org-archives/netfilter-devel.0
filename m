From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Update SNMP basic for full IP address NAT
Date: Thu, 23 Nov 2006 14:49:00 +0100
Message-ID: <4565A6CC.1090404@trash.net>
References: <3418F3471F1CA4409901547349FFAE2E05A05077@FTRDMEL2.rd.francetele	com.fr>
	<455AB76C.9050603@trash.net> <455C7E46.6080404@orange-ftgroup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Gilles Kerdoncuff <gkerdoncuff.ext@orange-ftgroup.com>
In-Reply-To: <455C7E46.6080404@orange-ftgroup.com>
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
> ** I understand that you'd like to keep the /8 behavior, yet, something
> still troubles me with the current ip_nat_snmp_basic.c file :
> 
> The from/to fields of the oct1_map structure are filled-in by calling
> the NOCT1 (0xFF mask) macro on the tuple IP.
> Which means that on a 192.168.1.x address, it takes the x part.

I'm confused - you seem to be right, but quick testing shows it behaves
correctly and takes the 192 part.

> On the second hand, the mangle_address routine is called with
> "ctx->pointer - 4", which points to the beginning of the IP. So, the
> routine will compare the x part to the '192' part !!
> 
> Am I misinterpretting the code or is it really a bug ?
> My understanding is that the '192' part of the address should be subject
> to the NAT translation, correct ?

Yes.

> ** Anyway, if any use case for the /8 behavior exists, I don't mind
> adding a parameter to test only the first 8,16,24 or 32 bits of the
> address, keeping /8 as a default.

Please do so. But why only 8,16,24,32? I don't believe allowing
any prefix len will be harder to do.
