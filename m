From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Classifying packets with the CLASSIFY Target
Date: Mon, 5 Jul 2004 12:10:28 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0407051204230.24656-100000@filer.marasystems.com>
References: <200407050854.i658sZMX029019@madinah.ccse.kfupm.edu.sa>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Muhammad R. Sami" <sami@ccse.kfupm.edu.sa>
In-Reply-To: <200407050854.i658sZMX029019@madinah.ccse.kfupm.edu.sa>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 5 Jul 2004, Muhammad R. Sami wrote:

> Now as the author states that the above command "Classifies packets of an
> established session between 40 and 100 bytes", I would like to ask what does
> 1:10 exactly mean.

It is a classid within the Linux traffic shaper class hierarchy, defined
by using the tc command.

See the Linux traffic shaping howto and related documentation on how to 
define traffic shaper classes.

Using the CLASSIFY target in iptables is an alternative method of 
classifying packets for the Linux traffic shaper, complementing the 
tc filter scheme.

Regards
Henrik
