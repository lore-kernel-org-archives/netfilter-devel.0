From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: HTTP info filter
Date: Fri, 5 Aug 2005 08:32:17 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0508050829150.20623@yvahk01.tjqt.qr>
References: <mnet1.1123173055.14289.joer@netcourrier.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: joer@netcourrier.com
In-Reply-To: <mnet1.1123173055.14289.joer@netcourrier.com>
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

>Hi all,
>
>I want to filter an outgoing HTTP request using its info field.
>ex : HTTP "GET /toto://hello/xxx"
>For every HTTP request with toto in info field, I wan't to get the xxx field. This request can be dropped.
>Can I do this with iptables ?
>Is there another tool for this ?

-j DROP -m layer7 --l7proto mytoto

Have a  /etc/l7-protocols/mytoto:
GET /toto://hello/xxx

This will drop these packets, but I currently do not know of a way to capture 
the xxx for further logging.



Jan Engelhardt
-- 
