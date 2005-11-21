From: Roberto Nibali <ratz@tac.ch>
Subject: Re: tcpmss code in 2.4.32
Date: Mon, 21 Nov 2005 10:54:58 +0100
Message-ID: <43819972.7060302@tac.ch>
References: <23952.217.169.232.210.1132561626.squirrel@hupie.xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: ferry@Hupie.com
In-Reply-To: <23952.217.169.232.210.1132561626.squirrel@hupie.xs4all.nl>
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

Hello,

> I'm looking at the code of the tcpmss match module in 2.4.32
> It looks like the find_syn_match inline function is not used and is just a
> copy-n-paste from the tcpmss target. Should it be removed?

It's not used, you're correct. It could be removed, however the 2.4.x
kernel is in maintenance mode only, so unless you fix something with a
patch you might have a hard time getting the patch in.

Regards,
Roberto Nibali, ratz
-- 
-------------------------------------------------------------
addr://Kasinostrasse 30, CH-5001 Aarau tel://++41 62 823 9355
http://www.terreactive.com             fax://++41 62 823 9356
-------------------------------------------------------------
terreActive AG                       Wir sichern Ihren Erfolg
-------------------------------------------------------------
