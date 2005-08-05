From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: HTTP info filter
Date: Fri, 5 Aug 2005 11:31:22 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0508051130110.7310@filer.marasystems.com>
References: <mnet1.1123173055.14289.joer@netcourrier.com>
	<Pine.LNX.4.61.0508050829150.20623@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
In-Reply-To: <Pine.LNX.4.61.0508050829150.20623@yvahk01.tjqt.qr>
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

On Fri, 5 Aug 2005, Jan Engelhardt wrote:

> This will drop these packets, but I currently do not know of a way to capture
> the xxx for further logging.

One way is to use QUEUE instead of DROP and write a small QUEUE handler 
application taking care of the logging.

Another is to write your own netfilter target for the logging purpose.

Regards
Henrik
