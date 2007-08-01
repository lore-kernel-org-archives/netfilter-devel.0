From: kewlemer <kewlemer@gmail.com>
Subject: Application data hook handler
Date: Wed, 1 Aug 2007 12:08:04 -0700
Message-ID: <79cbe6750708011208h6367228aybf8f5f06fa3609df@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
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

Hi all,

I'm a newbie to netfiler hacking. I've been reading the netfilter
framework code and iptables code and have a basic understanding of
these.

As an starting experiment I would like to write netfilter hook handler
function (called from  hooks in the IP stack) that dumps the
application data information (like  ipt_LOG.c). I understand that from
a networking perspective, looking at application data at IP level is
not a good thing to do, but I just want to experiment.

Can someone please give some pointers as to how I can start off or
some references that could be useful for this exercise.

Thanks very much,
KM
