From: Sander Eikelenboom <S.Eikelenboom@stud.tue.nl>
Subject: Re[2]: pptp-conntrack-nat: ip_nat_proto_gre.c:gre_manip_pkt: can't
	nat GRE w/o key
Date: Mon, 4 Apr 2005 13:09:34 +0200
Message-ID: <354301401.20050404130934@stud.tue.nl>
References: <222203005.20050403135647@stud.tue.nl>
	<20050404090850.GP9155@sunbeam.de.gnumonks.org>
Reply-To: Sander Eikelenboom <S.Eikelenboom@stud.tue.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050404090850.GP9155@sunbeam.de.gnumonks.org>
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

It works for me :-)
(doing this by VPN on linux 2.6.10 now :-) )

If i'm correct there are still issues with applying it to 2.6.11 ?



HW> On Sun, Apr 03, 2005 at 01:56:47PM +0200, Sander Eikelenboom wrote:
>> It seems pptp code is working now with 2.6.10, now the gre code needs some
>> tweaks. 

HW> please see my reply in bugzilla at
HW> https://bugzilla.netfilter.org/bugzilla/show_bug.cgi?id=319

HW> Can you please test and report back? Thanks.
