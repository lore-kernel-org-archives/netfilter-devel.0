From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Change Packet Payload
Date: Tue, 13 Feb 2007 23:10:16 +0100
Message-ID: <45D23748.2090609@netfilter.org>
References: <1171012218.4162.27.camel@LinuxCampo>
	<1171013512.18531.5.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org, Luis Campo Giralte <lcg223@tid.es>
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <1171013512.18531.5.camel@localhost>
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

Hi Eric,

Eric Leblond wrote:
> Le vendredi 09 février 2007 à 10:10 +0100, Luis Campo Giralte a écrit :
>> Hi every one!
>> im using libnetfilter_queue lib, its posible to change any value of the
>> packet, source address, icmp types, payload chars, or any data of the
>> packet received on the Handler (nfq_create_queue(h,0,&MyHandler,NULL))
>> and send it again with the correct checksum?
> 
> Yes, but you have to compute the checksum yourself.

I would accept a patch to introduce a function that computes the
checksum. I think that the library should provide as much helper
functions as possible. We can group such helper functions by protocols
in different files inside the libnetfilter_queue tree. I have already
seen several post in the mailing list on how to retrieve data from the
header and such.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
