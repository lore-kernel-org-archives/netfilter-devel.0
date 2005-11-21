From: "Ferry Huberts" <ferry@Hupie.com>
Subject: tcpmss code in 2.4.32
Date: Mon, 21 Nov 2005 09:27:06 +0100 (CET)
Message-ID: <23952.217.169.232.210.1132561626.squirrel@hupie.xs4all.nl>
Reply-To: ferry@Hupie.com
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi,

I'm looking at the code of the tcpmss match module in 2.4.32
It looks like the find_syn_match inline function is not used and is just a
copy-n-paste from the tcpmss target. Should it be removed?


--
Ferry Huberts
