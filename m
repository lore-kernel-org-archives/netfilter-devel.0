From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: Missed any patches? [PATCH] expectation timeouts
Date: Sat, 11 Jun 2005 19:14:41 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0506111913540.22504@yvahk01.tjqt.qr>
References: <42AB1577.5040006@trash.net> <20050611170739.GA5018@linuxace.com>
	<42AB1B05.2060509@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42AB1B05.2060509@trash.net>
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

>> Since expectation timeouts were made compulsory [1], there is no need to
>> check for them in ip_conntrack_expect_insert.
>
>Thanks, I just found it and am about to apply it to my 2.6.13 tree.

Is there any chance that all of POMng will get updated? Most of the patches 
still address a 2.6.<10 kernel. I have not tested if they apply correctly (I 
don't need them ... yet), but if they don't, rediff could be wise.


CHS,
Jan Engelhardt                                                               
--                                                                            
| Gesellschaft fuer Wissenschaftliche Datenverarbeitung Goettingen,
| Am Fassberg, 37077 Goettingen, www.gwdg.de
