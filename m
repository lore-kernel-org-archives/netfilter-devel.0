From: Kevin McConnell <kevymac@yahoo.com>
Subject: Re: ip_nat|conntrack_h323.c on 2.6
Date: Mon, 13 Dec 2004 20:48:23 -0800 (PST)
Message-ID: <20041214044823.48201.qmail@web50502.mail.yahoo.com>
References: <20041209193823.GA6216@roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Max Kellermann <max@duempel.org>, netfilter-devel@lists.netfilter.org
In-Reply-To: <20041209193823.GA6216@roonstrasse.net>
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


--- Max Kellermann <max@duempel.org> wrote:

> Hi,
> 
> is there already a 2.6 port of the h323 conntrack
> helper? pom-ng has
> only an implementation for 2.4, and the info file
> says it requires
> linux < 2.6. If there is no port, I will do it.

I believe there is not a 2.6 port of the h323
conntrack helper at this time, as it's been asked on
this list several dozen times at least. The general
reply I've seen is that it was a pretty ugly hack to
get it working and that it needed to be completely
rewritten, and will ultimately be replaced by more up
to date transports. I'd say, since nobody replied to
it, that if you'd like to undertake porting it, that
many people on this list (including myself) would be
pretty greatful if you got working.

> Max

TIA ;)
Kevin

=====
Kevin C. McConnell --RHCE # 805299480800193 since July 2, 1999-- <Red Hat Certified Engineer>
Freedom in software, now freedom in life.
http://www.freestateproject.org/


		
__________________________________ 
Do you Yahoo!? 
Jazz up your holiday email with celebrity designs. Learn more. 
http://celebrity.mail.yahoo.com
