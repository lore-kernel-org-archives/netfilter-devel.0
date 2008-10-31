From: "Jacky Luk" <jacky.luk@primecreation.com>
Subject: About the netfilter_queue and multi threads!
Date: Fri, 31 Oct 2008 18:45:23 +0800
Message-ID: <web-4608013@mail.primecreation.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
To: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi, 

Does the netfilter_queue support the multi-thread 
processing? In other words, I use one thread to receive 
packets from the netfilter_queue (Use recv() function). In 
the meanwhile, I dispatch them to other threads (Another 6 
threads) to process by using Round-Robin method (Use 
nfq_set_verdict() function when the processing is 
finished). If so, does it cause any stability issues to 
the system (e.g. Cause kernel panic)?

Thank you very much!

Regards,

Jacky Luk
