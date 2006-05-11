From: Holger Eitzenberger <heitzenberger@astaro.com>
Subject: Re: [RFC] [PATCH] clean up nf_log API
Date: Thu, 11 May 2006 10:54:54 +0200
Message-ID: <4462FBDE.20609@astaro.com>
References: <20060510191034.GA29531@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20060510191034.GA29531@sunbeam.de.gnumonks.org>
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

Harald Welte wrote:

> b) reference counting.  We could actually get_module / put_module the
>    module that implements a specific backend rather than using our own
>    use counter.

Yes, I saw this during nfnetlink_log evaluation.  It is kind of 
confusing if the module refcount stays zero all the time.

/holger


-- 
Holger Eitzenberger <heitzenberger@astaro.com> | Kernel Developer
Astaro AG | www.astaro.com | Phone +49-721-25516-246 | Fax -200

Astaro Security Linux
- PC Magazine Best of the Year 2004/2005
- CRN Best of the Year 2005
- SC Magazine "Best Buy" & 5 star rating - October 2005, Best of the 
Year 2005
- Internet Professionell "Empfehlung der Redaktion" - November 2005
