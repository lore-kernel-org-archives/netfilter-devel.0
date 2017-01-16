From: Artur Molchanov <arturmolchanov@gmail.com>
Subject: bridge: netfilter: Fix dropping packets that moving through
 bridge interface
Date: Mon, 16 Jan 2017 21:44:10 +0300
Message-ID: <e7fd1864-91dc-ca2d-8ce5-4cb7b589f1f5@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: stable@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

commit 14221cc45caad2fcab3a8543234bb7eda9b540d5 upstream.

Please apply this commit to fix bug that makes impossible to use local 
Docker containers with bridge network.

Cc: <stable@vger.kernel.org> # 4.9.x
