From: Eicke Friedrich <tady@gmx.net>
Subject: Re: Feasability of Protocol Filtering
Date: Fri, 25 Apr 2003 11:03:47 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EA8F9F3.4010401@gmx.net>
References: <Pine.LNX.4.44+maildir.0304221620090.1447-100000@woozle.org> <20030425083150.GG6439@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20030425083150.GG6439@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Patrick Schaaf wrote:
>>Identify and DENY SSH traffic regardless of port
> How do you cope with an ftp transfer of a tcpdump capture of some
> earlier SSH traffic?
Hmm, kind of difficult but this depends on the things you know about a 
protocol and of course on luck :-)
If you know the exact position (like the second byte in the payload of 
a packet has to be 0xff) of a characteristic string or pattern of 
bytes you don't need to search the whole packet. If it's not at this 
position it isn't the protocol that you're looking for.
What i mean is that if you transfer a captured ssh-session the chances 
that the characteristic string/pattern/whatever of ssh is at the same 
postion in the ftp transfer as it was in the original ssh connection 
are very low because ftp-data uses bigger packets than ssh.
What you also can do is including packet sizes in your test - for 
example excluding large packets (like ftp-data-packets are) from 
searching for ssh-characteristics.
I know that this was just an example but what i try to say is that if 
you learn much about the protocol an implement everything you know you 
will have a good chance to catch just the things you want to.


Regards,
Eicke.
