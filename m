From: Henrik Nordstrom <hno@marasystems.com>
Subject: RE: Interfacing custom application with iptables
Date: Wed, 23 Jun 2004 16:31:05 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0406231629170.7145-100000@filer.marasystems.com>
References: <200406231049.i5NAn1MX012895@madinah.ccse.kfupm.edu.sa>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Muhammad R. Sami" <sami@ccse.kfupm.edu.sa>
In-Reply-To: <200406231049.i5NAn1MX012895@madinah.ccse.kfupm.edu.sa>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 23 Jun 2004, Muhammad R. Sami wrote:

> Can I issue ioctl system calls from within my libipq application program to
> configure routing from my application, if yes, can anyone please provide me
> with some example code on how to perform this task.

Probably, but it is not an iptables question.

See the iproute2 package and/or related mailing list.

Personally I would call the ip command to change routing.

routing has several more or less well defined interfaces in several 
generations.

Regards
Henrik
