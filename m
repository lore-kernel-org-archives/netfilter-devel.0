From: "Muhammad R. Sami" <sami@ccse.kfupm.edu.sa>
Subject: RE: Problems using libipq/QUEUE
Date: Wed, 30 Jun 2004 20:52:22 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200406301753.i5UHr3MX025697@madinah.ccse.kfupm.edu.sa>
References: <200406301704.i5UH4EMX025110@madinah.ccse.kfupm.edu.sa>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "'Netfilter List'" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "'Henrik Nordstrom'" <hno@marasystems.com>
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

I am simply using the same example in the manpage. The nfmark is being used
within the libipq application program (status = ipq_set_verdict(h,
m->packet_id,
                                                         NF_ACCEPT, 0,
NULL);.

Still it doesn't seem to work
Regards,
