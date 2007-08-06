From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] ulogd mysql fix
Date: Mon, 06 Aug 2007 10:54:19 +0200
Message-ID: <46B6E1BB.5040400@netfilter.org>
References: <1185968915.30855.9.camel@khasse.inl.fr>	
	<46B08559.7040001@netfilter.org>
	<1185975806.15499.3.camel@khasse.inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <1185975806.15499.3.camel@khasse.inl.fr>
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

Eric Leblond wrote:
> In fact, MYSQL_OPT_RECONNECT option has been introduced in MySQL 5.0.13
> to restore the capability to reconnect to server after inactivity.
> Furthermore, the functionnality was partially broken before 5.0.19 and
> this explains the two calls to mysql_option.

Ick! scary thing. Two point less for the mysql guys... Applied, thanks Eric.

-- 
"Será preciso viajar a través de los ojos de los idiotas" -- Poeta en
Nueva York -- Federico García Lorca.
