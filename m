From: Henrik Nordstrom <hno@marasystems.com>
Subject: RE: Problems using libipq/QUEUE
Date: Wed, 30 Jun 2004 21:17:35 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0406302115210.13036-100000@filer.marasystems.com>
References: <200406301704.i5UH4EMX025110@madinah.ccse.kfupm.edu.sa>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Muhammad R. Sami" <sami@ccse.kfupm.edu.sa>
In-Reply-To: <200406301704.i5UH4EMX025110@madinah.ccse.kfupm.edu.sa>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 30 Jun 2004, Muhammad R. Sami wrote:

> I am simply using the same example in the manpage. The nfmark is being
> used within the libipq application program (status = ipq_set_verdict(h,
> m->packet_id, NF_ACCEPT, 0, NULL);.

There is no nfmark in ipq_set_verdict... only in the packet data you get 
in ipq_get_packet()

To have meaningful nfmark values sent to your application via QUEUE you 
must first have something assigning meaningful nfmark values to the 
packets before sent to QUEUE, e.g. via the MARK action or similar.

Regards
Henrik
