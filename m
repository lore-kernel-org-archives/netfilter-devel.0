From: Henrik Nordstrom <hno@marasystems.com>
Subject: RE: Userspace queuing
Date: Mon, 28 Jun 2004 11:45:23 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0406281034460.12179-100000@filer.marasystems.com>
References: <200406280718.i5S7I1MX005242@madinah.ccse.kfupm.edu.sa>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Muhammad R. Sami" <sami@ccse.kfupm.edu.sa>
In-Reply-To: <200406280718.i5S7I1MX005242@madinah.ccse.kfupm.edu.sa>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 28 Jun 2004, Muhammad R. Sami wrote:

> Thanks Henrik for your help, I have 2 questions, first of all I could not
> find anyway to extract and read packet payload through libipq, I know it has
> a function to do so but how to use it (any examples??)

See the very extensive documentation included in libipq.

> and secondly is there any implementation of priority queues (multiple
> FIFOs) at userspace using libipq.

Not that I know of, but I thougt this was what you wanted to implement 
yourself..

What is it actually that you want to do?

Regards
Henrik
