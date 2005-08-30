From: Kris <kris@theendless.org>
Subject: Implementing --log-uid in to a 2.4.x kernel
Date: Tue, 30 Aug 2005 15:09:50 -0400 (EDT)
Message-ID: <Pine.LNX.4.63.0508301507100.12743@morpheus.theendless.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi,
 	I'd like to implement this feature in to the 2.4.x kernel as it is 
currently only supported in 2.6.x.  However, I would like to know if 
anyone can shed some light on why it isn't already included?  Is this a 
futile or difficult task?  I'd think that since there is already 
owner-match support in 2.4.x it would be trivial to hack in the --log-uid 
support as the information is obviously available to the kernel and the 
netfilter API.  No?

Thanks, any help is appreciated!

Kris
