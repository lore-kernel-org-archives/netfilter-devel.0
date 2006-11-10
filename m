From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC] new API for libnetfilter_conntrack
Date: Fri, 10 Nov 2006 20:07:05 +0100
Message-ID: <4554CDD9.9050106@netfilter.org>
References: <45456285.4010609@netfilter.org> <20061107192458.GJ4423@(none)>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>, Eric Leblond <eric@inl.fr>
In-Reply-To: <20061107192458.GJ4423@(none)>
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
>> This will result in a single library to rules them all with a
>> subdirectory that contains the details of every specific subsystem.
> 
> I disagree with that proposition.  I don't really understand why
> completely independent netfilter subsystems should share a high-level
> userspace library.  Every time some obscure bug in libnetfilter_log
> happens, libnetfilter_conntrack will be affected, too.
> 
> This is especially difficult if meanwhile you have commited
> not-yet-completely-stable code for one subsystem, and then need to make
> a bugfix releease of the other (svn branching is an option, but it all
> sounds a bit too complex for my taste).

Yes, this is a tricky issue, although the libraries are relatively small 
in terms of code and the impact of such problem could be reduced if we 
do frequent releases.

> One option would be implement the subsystem specific parts as plugins
> and to dlopen() them at runtime, providing a way of updating only
> individual subystem-plugins

As I posted days ago, this is an alternative that I like, such dlopen() 
would require a versioning mechanism, the only concerned here is about 
getting people confused with this modular view.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
