From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: Locking issue
Date: Thu, 16 Aug 2007 20:11:45 +0200
Message-ID: <1187287905.3005.2.camel@localhost.localdomain>
References: <177537.47029.qm@web7913.mail.in.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Abhinav Srivastava <abhinavs_iitkgp@yahoo.co.in>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <177537.47029.qm@web7913.mail.in.yahoo.com>
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

Op do, 16-08-2007 te 18:54 +0100, schreef Abhinav Srivastava:
> 
> Hi there,
> 
> This email is regarding ebtables code i.e. bridge
> level filtering framework of netfilter. I have sent
> this email to ebtables mailing list also but have not
> heard from anyone. Hence, am sending this here too. I
> hope i will receive some favorable response.
> 
> I am new to ebtables code and looking for some help
> related to locking and atomicity. I am interested in
> looking into the packets intercepted by ebtables,
> extract some information, pass this information to
> userspace, wait for userspace response and then pass
> the result back to ebtable code.

What you seek is a QUEUE target as it exists for iptables. Unfortunately
this doesn't yet exist for ebtables. Maybe you can get away with it by
using the ebtables ulog watcher.

cheers,
Bart
