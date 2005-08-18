From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: string match for 2.6?
Date: Thu, 18 Aug 2005 17:47:33 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0508181745510.1090@yvahk01.tjqt.qr>
References: <4303540E.30503@xs4all.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Udo van den Heuvel <udovdh@xs4all.nl>
In-Reply-To: <4303540E.30503@xs4all.nl>
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

>Can anyone please tell about the plans for updating the string match to
>the 2.6 tree?

(Don't know much about string's 2.6 fitness, so it's
neither "plans" nor "no plans")

>If there are no plans: what could be my best alternatives?

l7-filter.sf.net -- you can "abuse" it to have some string matching. It also 
has regexes, so if you need that, you're in best hands ;)
Note however that regexes may take slightly more CPU.



Jan Engelhardt
-- 
